App.InstallerStep3Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep2')
        next: ->
            @get('controllers.installer').send('gotoStep4')