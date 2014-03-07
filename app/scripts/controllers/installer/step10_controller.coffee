App.InstallerStep10Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep9')
        finish: ->
            @get('controllers.installer').setCurrentStep(0)
            @transitionToRoute('index')