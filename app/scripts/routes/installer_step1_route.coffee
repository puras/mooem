App.InstallerStep1Route = Ember.Route.extend
    beforeModel: ->
        console.log 'beforeModel'
        controller = @controllerFor('installer')
        controller.setCurrentStep(1, false)
        controller.clear_install_options()