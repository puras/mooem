App.InstallerStep7Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(7, false)