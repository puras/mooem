App.InstallerStep6View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        #@set('controller.hosts_error', null)
        #@set('controller.ssh_key_error', null)

    is_file_api: (->
        (window.File && window.FileReader && window.FileList) ? true : false
    ).property()

App.SSHKeyFileUploader = Ember.View.extend
    template: Ember.Handlebars.compile('<input type="file" {{bind-attr disabled="view.disabled"}} />')