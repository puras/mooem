App.InstallerStep9Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(9, false)