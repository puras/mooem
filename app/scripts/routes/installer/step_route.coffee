App.StepRoute = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        console.log 'in parent',controller.get_step @
        controller.setCurrentStep controller.get_step @, false