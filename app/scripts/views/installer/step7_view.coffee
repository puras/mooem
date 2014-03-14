App.InstallerStep7View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        @get('controller').load_step()
