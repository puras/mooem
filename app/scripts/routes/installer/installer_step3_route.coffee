App.InstallerStep3Route = App.StepRoute.extend
    model: ->
        # @store.find 'template'
        @store.find('template').then (ts)->
            temps = ts.filter (t) ->
                t.get('pid') == 0
    setupController: (controller, model) -> 
        console.log 'setupController'
        console.log model
        controller.set 'templates', model