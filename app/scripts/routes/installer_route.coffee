App.InstallerIndexRoute = Ember.Route.extend
    beforeModel: ()->
        controller = @controllerFor('installer')
        console.log controller
        controller.setCurrentStep 0
        @transitionTo '/installer/step0'