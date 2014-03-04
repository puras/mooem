App.InstallerIndexRoute = Ember.Route.extend
    setupController: (controller, model) ->
        console.log controller.get('currentStep')