
class Speaker
    constructor: (shower) ->
        @debuger = shower.debuger
        @boardNode = shower.boardNode
    errorFriendly: (err) ->
        @boardNode.appendChild document.createTextNode err + '\n'
        @debuger.error err
        return err
    error: (err) ->
        @debuger.error err
    log: (lg) ->
        @debuger.log lg


spexif.speaker = new Speaker {
    debuger: window.console
    boardNode: document.getElementById 'error-board'
}

