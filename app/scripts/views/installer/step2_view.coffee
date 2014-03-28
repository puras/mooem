App.InstallerStep2View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        @get('controller').load_step()

App.WizardHostView = Ember.View.extend
    tagName: 'tr'
    host_info: null

    removable: (->
        true
    ).property()
    retryable: (->
        return true
    ).property()
    #).property(host_info.boot_status)