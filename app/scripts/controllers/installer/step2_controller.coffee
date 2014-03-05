App.InstallerStep2Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep1')
        next: ->
            @get('controllers.installer').send('gotoStep3')