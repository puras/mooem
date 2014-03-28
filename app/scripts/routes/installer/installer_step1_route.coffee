App.InstallerStep1Route = App.StepRoute.extend
    beforeModel: ->
        @_super()
        controller = @controllerFor('installer')
        controller.clear_install_options()