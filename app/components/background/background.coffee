background_module = 

  previous_content: []

  content: (event)->
    # extracting out the urls into hashable from would be vendor-specific: abstract out.
    
    # TODO case for chrome
    # chrome.tabs.query

  listen: (event_id, callback) ->
    # translate our event_id to a vendor implementation.

    # case: chrome
    chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
      console.log { tabId, changeInfo, tab }

    # handle messaging from extension components
    chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
      # chrome.pageAction.show(sender.tab.id)
      # sendResponse()

      console.log
        msg: "message received by background!"
        request
        sender,
        sendResponse


# doit.
background_module.listen 'chrome.tabs', (event)-> 

  # filter for our events: new url in any of the window content.
  content = content(event)

  $socket.push {
    urls: [
      diff_hash @previous_content, content
    ]
    event: event
  }

  # let's get a snapshot so we can diff.
  @previous_content = content



# TODO set up dependency to angular and implement externals. $socket

# TODO decide how code modules will be loaded from here, given brunch concats them to app.js.

# TODO after laying out initial version, factor out vendor-specifics and fit it into the packaging scheme.


