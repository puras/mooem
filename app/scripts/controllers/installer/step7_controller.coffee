App.InstallerStep7Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep6')
        next: ->
            @get('controllers.installer').send('gotoStep8')