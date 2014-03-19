App.InstallerStep1Route = Ember.Route.extend(
    beforeModel: ->
        console.log '1'
        controller = @controllerFor('installer')
        controller.setCurrentStep(1, false))