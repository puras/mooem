App.InstallerStep1Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(0, false)
            @get('controllers.installer').send('gotoStep0')
        next: ->
            @get('controllers.installer').setCurrentStep(2, false)
            @get('controllers.installer').send('gotoStep2')