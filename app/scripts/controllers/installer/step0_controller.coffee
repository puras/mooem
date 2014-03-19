App.InstallerStep0Controller = Ember.Controller.extend
    name: 'wizardStep0Controller'

    needs: ['installer']
    actions:
        next: ->
            @get('controllers.installer').setCurrentStep(1, false)
            @get('controllers.installer').send('gotoStep1')