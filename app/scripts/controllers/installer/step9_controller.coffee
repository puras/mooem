App.InstallerStep9Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep8')
        next: ->
            @get('controllers.installer').send('gotoStep10')