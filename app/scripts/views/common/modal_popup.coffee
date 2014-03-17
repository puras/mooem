App.ModalPopup = Ember.View.extend
    viewName: 'modalPopup'
    templateName: 'common/modal_popup'
    header: '&nbsp;'
    body: '&nbsp;'
    encode_body: true
    primary: 'Ok'
    secondary: 'cancel'
    auto_height: false
    enable_primary: true

    show_close_button: true

    didInsertElement: ->
        @.$().modal('show')
        ###
        if @auto_height
            block = @.$().find('#modal > .modal-body').first()
            #block.css 'max-height', $(window).height() - block.offset().top() - 300 + $(window).scrollTop()

        existed_popups = $(document).find('.modal-backdrop')
        if existed_popups
            max_zindex = 1
            existed_popups.each (idx, popup) ->
                if $(popup).css('z-index') > max_zindex
                    max_zindex = $(popup).css('z-index')
        @.$().find('.modal-backdrop').css('z-index', max_zindex * 2)
        @.$().find('.modal').css('z-index', max_zindex * 2 + 1)
        console.log 'test============================='
        ###


App.ModalPopup.reopenClass
    show: (options) ->
        console.log 'show----------------------------'
        popup = @create options
        popup.appendTo App.rootElement