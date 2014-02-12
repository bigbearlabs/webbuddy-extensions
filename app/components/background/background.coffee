background_module = 
  stack_requests: {}

  listen: (event_id, callback) =>
    # translate our event_id to a vendor implementation.

    switch event_id
      when 'new_url'
        # case: chrome
        chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) =>
          console.log { msg:'DEBUG', tabId, changeInfo, tab }

          # filter for our events: new url in any of the window content.
          if tab.status == 'loading' or tab.status == 'complete'
            chrome.tabs.captureVisibleTab tab.windowId, {format: 'png'}, (thumbnail_data_url)=>
              callback {
                id: event_id
                url: tab.url
                status: tab.status
                thumbnail_data: thumbnail_data_url
              }

      when 'msg'

        ## handle messaging from extension components
        # case 'chrome'
        chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
          # e.g.
          # chrome.pageAction.show(sender.tab.id)
          # sendResponse()

          callback {
            id: event_id
            event_params: [ request, sender, sendResponse ]
          }

  post_stack: (event)->
    console.log
      msg: 'posting stack to server.'
      data: event
      
    xhreq = new XMLHttpRequest()
    xhreq.open "POST", "http://localhost:59124/stacks"
    xhreq.onreadystatechange = ->
      return unless xhreq.readyState is 4
      response = xhreq.responseText
      console.log response

    xhreq.send JSON.stringify event

  post_page: (event)->
    console.log
      msg: 'posting page to server.'
      data: event

    xhreq = new XMLHttpRequest()
    xhreq.open "POST", "http://localhost:59124/stacks/#{event.window_id}/pages"
    xhreq.onreadystatechange = ->
      return unless xhreq.readyState is 4
      response = xhreq.responseText
      console.log response

    xhreq.send JSON.stringify event


## doit

# listen for scope changes from ui and update recording scope.
# TODO

# listen for new window and use default strategy to add it to scope (or not).
# TODO filter new url's for windows in scope.

# listen for new urls and post if in scope.
background_module.listen 'new_url', (event)=> 

  window_id = 'stub chrome window'

  # once-only stack creation.
  unless background_module.stack_requests[window_id]
    background_module.post_stack
      name: window_id
      window_id: window_id

    background_module.stack_requests[window_id] = window_id

  event_data =
    window_id: window_id
    url: event.url
    status: event.status
    thumbnail_data: event.thumbnail_data

  # TODO post to repository.
  background_module.post_page(event_data)


console.log 'background script loaded.'


# TODO set up dependency to angular and implement externals. $socket

# TODO decide how code modules will be loaded from here, given brunch concats them to app.js.

# TODO after laying out initial version, factor out vendor-specifics and fit it into the packaging scheme.


