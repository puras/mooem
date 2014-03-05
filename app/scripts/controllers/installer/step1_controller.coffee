App.InstallerStep1Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep0')
        next: ->
            @get('controllers.installer').send('gotoStep2')