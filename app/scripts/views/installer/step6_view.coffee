App.InstallerStep6View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        @get('controller').load_data()