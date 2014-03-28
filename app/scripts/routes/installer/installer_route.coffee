App.InstallerIndexRoute = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('application')
        currentStep = parseInt(controller.getInstallerCurrentStep(), 10)
        if isNaN(currentStep)
            currentStep = 0
        @transitionTo '/installer/step' + currentStep
