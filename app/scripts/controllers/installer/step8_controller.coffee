App.InstallerStep8Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep7')
        next: ->
            @get('controllers.installer').send('gotoStep9')