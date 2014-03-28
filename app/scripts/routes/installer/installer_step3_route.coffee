App.InstallerStep3Route = App.StepRoute.extend
    model: ->
        console.log 'model'
        @store.find 'template'
    setupController: (controller, model) -> 
        console.log 'setupController'
        controller.set 'templates', model