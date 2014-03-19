App.InstallerStep9Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(8, false)
            @get('controllers.installer').send('gotoStep8')
        next: ->
            @get('controllers.installer').setCurrentStep(10, false)
            @get('controllers.installer').send('gotoStep10')