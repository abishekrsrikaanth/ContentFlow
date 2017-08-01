
class SnippetUI extends ContentTools.ComponentUI

    # A UI component representing a snippet within a content flow

    constructor: (snippet, behaviour) ->

        # The snippet the component represents
        @_snippet = snippet

        # The behaviour the snippet will support:
        #
        # - 'pick'   allow the snippet to be picked (you pick a snippet when
        #            adding one).
        # - 'manage' allow the snippet to be managed (settings, scrope and
        #            delete tools will be displayed within the snippet).
        # - 'order'  allow the snippet to be dragged within a its siblings to
        #            changes its position (the order).
        @_behaviour = behaviour

    # Methods

    mount: () ->
        super()

        # Create the DOM elements for the snippet, preview image, label and
        # tools

        # Snippet
        this._domElement = @constructor.createDiv([
            'ct-snippet',
            'ct-snippet--behaviour-' + @_behaviour,
            'ct-snippet--scope-' + @_snippet.scope
        ])
        this._domElement.setAttribute('data-snippet-id', snippet.id)

        # Preview image
        @_domPreview = @constructor.createDiv(['ct-snippet__preview'])
        if @_snippet.type.previewImage
            bkgURL = "url(#{ @_snippet.type.previewImage })"
            @_domPreview.style.backgroundImage = bkgURL
        @_domElement.appendChild(@_domPreview)

        # Label
        @_domLabel = @constructor.createDiv(['ct-snippet__label'])
        if @_snippet.label
            @_domLabel.textContent = snippet.label
        else
            @_domLabel.textContent = snippet.type.label
        @_domElement.appendChild(@_domLabel)

        # Tools (settings, scope, delete)
        if @_behaviour is 'manage'
            @_domTools = @constructor.createDiv(['ct-snippet__tools'])

            # Settings
            @_domSettingsTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--settings'
                ])
            @_domSettingsTool.setAttribute('data-ct-tooltip', 'Settings')
            @_domTools.appendChild(@_domSettingsTool)

            # Scope
            @_domScopeTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--scope'
                ])
            @_domScopeTool.setAttribute('data-ct-tooltip', 'Scope')
            @_domTools.appendChild(@_domScopeTool)

            # Delete
            @_domDeleteTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--delete'
                ])
            @_domDeleteTool.setAttribute('data-ct-tooltip', 'Delete')
            @_domTools.appendChild(@_domDeleteTool)

            @_domElement.appendChild(@_domTools)

        # Mount the snippet to the DOM
        @parent.domElement().appendChild(@_domElement)
        @_addDomEventListeners()

    # Private methods

    _addDOMEventListeners: () ->
        super()

        # Add common event handlers (over/out)
        @_domElement.addEventListener 'mouseover', (ev) =>
            @dispatchEvent(@createEvent('over', {snippet: snippet}))

        @_domElement.addEventListener 'mouseover', (ev) =>
            @dispatchEvent(@createEvent('out', {snippet: snippet}))

        if @_behaviour is 'manage'

            # Add event handlers for manage (settings, scope and delete)
            @_domSettingsTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('settings', {snippet: snippet}))

            @_domScopeTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('scope', {snippet: snippet}))

            @_domDeleteTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('delete', {snippet: snippet}))

        else if @_behaviour is 'pick'
            # Add event handlers for pick
            @_domElement.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('pick', {snippet: snippet}))