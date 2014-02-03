background_module = 

  listen: (event_id, callback) ->
    # translate our event_id to a vendor implementation.

    switch event_id
      when 'new_url'
        # case: chrome
        chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
          console.log { msg:'DEBUG', tabId, changeInfo, tab }

          # filter for our events: new url in any of the window content.
          if tab.status == 'loading'
            callback {
              id: event_id
              url: tab.url
              status: tab.status
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

  post: (event)->
    
    console.log
      msg: 'IMPL post to server.'
      data: event

    # TODO return thenable.


# doit.
background_module.listen 'new_url', (event)-> 

  event_data =
    msg: 'loading url'
    window_id: 'stub-window-id'
    url: event.url
    status: event.status

  # TODO post to repository.
  background_module.post( event_data)


console.log 'background script loaded.'


# TODO set up dependency to angular and implement externals. $socket

# TODO decide how code modules will be loaded from here, given brunch concats them to app.js.

# TODO after laying out initial version, factor out vendor-specifics and fit it into the packaging scheme.


