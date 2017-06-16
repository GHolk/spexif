
class Speaker
    constructor: (shower) ->
        @debuger = shower.debuger
        @boardNode = shower.boardNode

    errorTemplate:
        document.getElementById 'template'
            .getElementsByClassName('error-log')[0]

    logTemplate:
        document.getElementById 'template'
            .getElementsByClassName('normal-log')[0]

    errorFriendly: (err) ->
        node = @errorTemplate.cloneNode()
        node.textContent = err
        @boardNode.appendChild node
        @debuger.error err
        return err

    logFriendly: (log) ->
        node = @logTemplate.cloneNode()
        node.textContent = log
        @boardNode.appendChild node

    error: (err) ->
        @debuger.error err
    log: (lg) ->
        @debuger.log lg


spexif.speaker = new Speaker {
    debuger: window.console
    boardNode: document.getElementById 'error-board'
}

