App.InstallerStep0Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor 'installer'
        controller.setCurrentStep(0, false)