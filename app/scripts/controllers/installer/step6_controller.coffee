App.InstallerStep6Controller = App.StepController.extend
    relations: []
    load_data: ->
        App.ajax.send
            name: 'wizard.step6.load_resource_plugin_relation'
            sender: @
            success: 'load_resource_plugin_relation_success_callback'
            error: 'load_resource_plugin_relation_error_callback'
    load_resource_plugin_relation_success_callback: (data)->
        # @set 'relations', data.relations
        relations = []
        data.relations.forEach (rela) ->
            relation = App.ResourcePluginRelation.create
                id: rela.id
                address: rela.address
                plugin_name: rela.tarName
                is_checked: true
            relations.pushObject relation
        @set 'relations', relations
    load_resource_plugin_relation_error_callback: ->
        console.log 'load_resource_plugin_relation_error_callback'