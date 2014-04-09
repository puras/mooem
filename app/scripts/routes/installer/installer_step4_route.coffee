App.InstallerStep4Route = App.StepRoute.extend
    model: ->
        # @store.find 'template'
        @store.find('template').then (model)->
            model.filter (item)->
                item.get('pid') == 0
    setupController: (controller, model) -> 
        controller.set 'templates', model
        controller.set 'plugin_type', 'collection'