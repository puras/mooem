App.InstallerStep5Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep4')
        next: ->
            @get('controllers.installer').send('gotoStep6')