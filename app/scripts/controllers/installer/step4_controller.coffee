App.InstallerStep4Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(3, false)
            @get('controllers.installer').send('gotoStep3')
        next: ->
            @get('controllers.installer').setCurrentStep(5, false)
            @get('controllers.installer').send('gotoStep5')