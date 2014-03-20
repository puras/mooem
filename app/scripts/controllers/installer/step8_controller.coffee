App.InstallerStep8Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(7, false)
            @get('controllers.installer').send('gotoStep7')
        next: ->
            @get('controllers.installer').setCurrentStep(9, false)
            @get('controllers.installer').send('gotoStep9')