App.InstallerStep6Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep5')
        finish: ->
            @get('controllers.installer').setCurrentStep(0)
            @transitionToRoute('index')