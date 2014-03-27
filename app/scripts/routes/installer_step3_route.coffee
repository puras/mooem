App.InstallerStep3Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(controller.get_step @, false)
    model: ->
        console.log 'model'
        @store.find 'template'
    setupController: (controller, model) -> 
        console.log 'setupController'
        controller.set 'templates', model