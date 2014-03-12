App.InstallerStep6Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(6, false)
        controller.clear_install_options()