chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  # chrome.pageAction.show(sender.tab.id)
  # sendResponse()

  console.log
    msg: "message received by background!"
    request
    sender,
    sendResponse

  # TODO decide how code modules will be loaded from here, given brunch concats them to app.js.