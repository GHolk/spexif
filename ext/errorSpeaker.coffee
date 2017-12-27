
class Speaker
    constructor: (shower) ->
        @debuger = shower.debuger
        @boardNode = shower.boardNode
        @boardNode.querySelector 'iframe'
            .addEventListener 'load', (loadEvent) =>
                # check is not first load event
                if loadEvent.target.contentWindow.location.href != 'about:blank'
                    this.showWindow true
        @boardNode.querySelector 'button'
            .addEventListener 'click', => this.showWindow false

    errorTemplate:
        document.getElementById 'template'
            .getElementsByClassName('error-log')[0]

    logTemplate:
        document.getElementById 'template'
            .getElementsByClassName('normal-log')[0]

    errorFriendly: (err) ->
        node = @errorTemplate.cloneNode()
        node.textContent = err
        @showWindow false
        @boardNode.appendChild node
        @debuger.error err
        return err

    logFriendly: (log) ->
        node = @logTemplate.cloneNode()
        node.textContent = log
        @showWindow false
        @boardNode.appendChild node

    showWindow: (bool) ->
        if bool
            @boardNode.classList.add 'show-window'
        else
            @boardNode.classList.remove 'show-window'

    error: (err) ->
        @debuger.error err
    log: (lg) ->
        @debuger.log lg

spexif.speaker = new Speaker {
    debuger: window.console
    boardNode: document.querySelector '#error-board'
}

