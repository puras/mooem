App.InstallerStep3Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(2, false)
            @get('controllers.installer').send('gotoStep2')
        next: ->
            @get('controllers.installer').setCurrentStep(4, false)
            @get('controllers.installer').send('gotoStep4')