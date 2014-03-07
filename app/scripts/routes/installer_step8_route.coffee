App.InstallerStep8Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(8, false)