App.InstallerStep6Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep5')
        next: ->
            @get('controllers.installer').send('gotoStep7')