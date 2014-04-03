App.InstallerStep3Route = App.StepRoute.extend
    model: ->
        # @store.find 'template'
        @store.find('template').then (ts)->
            temps = ts.map (t) ->
                t
    setupController: (controller, model) -> 
        console.log 'setupController'
        controller.set 'templates', model