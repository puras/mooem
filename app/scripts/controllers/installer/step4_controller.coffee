App.InstallerStep4Controller = Ember.Controller.extend
    needs: ['installer']

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep3')
        next: ->
            @get('controllers.installer').send('gotoStep5')