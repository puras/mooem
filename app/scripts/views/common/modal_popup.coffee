App.ModalPopup = Ember.View.extend
    viewName: 'modalPopup'
    templateName: 'common/modal_popup'
    header: '&nbsp;'
    body: '&nbsp;'
    auto_height: true

    didInsertElement: ->
        if @auto_height
            block = @.$().find('#modal > .modal-body').first()
            block.css 'max-height', $(window).height() - block.offset.top - 300 + $(window).scrollTop()

App.ModalPopup.reopenClass
    show: (options) ->
        console.log options
        popup = @.create options
        popup.appendTo App.rootElement
        popup