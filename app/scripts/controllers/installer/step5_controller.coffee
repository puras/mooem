App.InstallerStep5Controller = App.StepController.extend
    parent_resource: null
    resources: []

    show_resource_form: false
    show_plugin_config: false
    show_agent_config: false

    templates: []
    template: null

    templateDidChange: (->
        if @get 'template'
            console.log @get 'template'
            App.ajax.send
                name: 'wizard.step5.load_template_attribute'
                sender: @
                data:
                    tid: @get('template').id
                success: 'load_template_attribute_success'
                error: 'load_template_attribute_error_callback'
        else
            @set 'attributes', []
            console.log 'template is null'
    ).observes('template')

    attributes: []
    show_attribute_form: (->
        @get('attributes').length > 0
    ).property('attributes')

    load_template_attribute_success: (data)->
        @set 'attributes', data.attributes
    load_template_attribute_error_callback: ->
        console.log 'load_template_attribute_error_callback'

    agents: []
    agent: null
    agentDidChange: ->
        console.log 'agent change'

    close_all_form: ->
        @set 'show_resource_form', false
        @set 'show_plugin_config', false
        @set 'show_agent_config', false

    load_templates: (res)->
        console.log 'load_templates'
        tid = 0
        if res then tid = res.tid
        App.ajax.send
            name: 'wizard.step3.load_template_children'
            sender: this
            data:
                pid: tid
            success: 'load_templates_success'
            error: 'load_templates_error_callback'
    load_templates_success: (data) ->
        if data and data.templates and data.templates.length > 0
            @set 'show_resource_form', true
            @set 'templates', data.templates
        else
            @set 'show_resource_form', false
            alert '該資源所用模板沒有子模板，無法創建子資源'
    load_templates_error_callback: ->
        console.log 'load_templates_error_callback'

    load_resources: ->
        App.ajax.send
            name: 'wizard.step5.load_resource_children'
            sender: @
            data:
                pid: 0
            success: 'load_resource_success'
            error: 'load_resource_error_callback'
    load_resource_success: (data) ->
        @set 'resources', data.resources
    load_resource_error_callback: ->
        console.log 'load_resource_error_callback'

    has_parent: (parent) ->
        if parent != null and (parent.toString().indexOf('Step5ChildContainerView') != -1 or parent.toString().indexOf('Step5ChildResourceView') != -1)
            true
        else
            false
    child_index_of: (arr, obj) ->
        idx = -1
        $.each arr, (i, o) ->
            if o.target == obj
                idx = i
                return
        idx

    load_resource_children: (resource) ->
        @set 'parent_resource', resource
        App.ajax.send
            name: 'wizard.step5.load_resource_children'
            sender: @
            data:
                pid: resource.id
            success: 'load_resource_children_success'
            error: 'load_resource_children_error_callback'
    load_resource_children_success: (data)->
        resource = @get 'parent_resource'
        container = Ember.View.views['child_resource_' + resource.id]

        views = container.get 'childViews'
        flag = false
        cview = null
        views.forEach (view) ->
            console.log view
            if view.get('parentResource').id == resource.id
                flag = true
                cview = view
        if flag
            container.removeChild cview
            $('#child_resource_' + resource.id).empty()
            return
        cons = Ember.View.views
        arr = []
        for con_str of cons
            if con_str.toString().indexOf('child_resource_') == 0
                con = Ember.View.views[con_str]
                if con == container
                    arr.push
                        target: con
                        flag: true
                    con_parent = con
                    while @has_parent con_parent
                        con_parent = con_parent.get 'parentView'
                        if @child_index_of(arr, con_parent) != -1
                            idx = @child_index_of arr, con_parent
                            arr[idx] = 
                                target: con_parent
                                flag: true
                        else
                            arr.push
                                target: con_parent
                                flag: true
                else
                    if @child_index_of(arr, con) == -1
                        arr.push
                            target: con
                            flag: false
        for con in arr
            if !con.flag
                con.target.removeAllChildren()
                $('#' + con.target.elementId).empty()

        child = container.createChildView App.Step5ChildResourceView
        child.set 'parentResource', resource
        child.set 'resources', data.resources
        container.pushObject child
    load_resource_children_error_callback: ->
        console.log 'load_resource_children_error_callback'
    save_resource_success: (data) ->
        if data.info is 'SUCCESS'
            alert '保存成功'
            @load_resources()
            @clear_resource_form()
        else
            alert '保存失败:' + data.error_message
    save_resource_error_callback: ->
        console.log 'save_resource_error_callback'

    remove_resource: (resource) ->
        @set 'current_resource', resource
        App.ajax.send
            name: 'wizard.step5.load_resource_children'
            sender: @
            data:
                pid: resource.id
            success: 'remove_resource_valid_success'
            error: 'remove_resource_valid_error_callback'
    remove_resource_valid_success: (data) ->
        console.log data
        console.log data.resources
        console.log data.resources.length
        if data and data.resources and data.resources.length > 0
            alert '该资源下还有子资源，需删除子资源后再删除该资源'
        else
            App.ajax.send
                name: 'wizard.step5.remove_resource'
                sender: @
                data:
                    rid: @get('current_resource').id
                success: 'remove_resource_success'
                error: 'remove_resource_error_callback'    
    remove_resource_valid_error_callback: ->
        console.log 'remove_resource_valid_error_callback'
    remove_resource_success: (data)->
        if data.info is 'SUCCESS'
            @load_resources()
            alert '删除成功'
        else 
            alert '删除失败: ' + data.error_message
    remove_resource_error_callback: ->
        console.log 'remove_resource_error_callback'
    clear_resource_form: ->
        @set 'template', null
        @set 'current_resource', null
        @set 'resource_name', null
        @set 'resource_desc', null
        @set 'attributes', []
        @set 'show_resource_form', false

    load_agents: ->
        App.ajax.send
            name: 'wizard.step5.load_agents'
            sender: @
            success: 'load_agent_success'
            error: 'load_agent_error_callback'
    load_agent_success: (data) ->
        agents = []
        data.agents.forEach (agent) ->
            agent.fullName = agent.address + ':' + agent.port
            agents.push agent
        @set 'agents', agents
        @set 'show_agent_config', true
    load_agent_error_callback: ->
        console.log 'load_agent_error_callback'
    save_agent_config_success: (data) ->
        if data.info == 'SUCCESS'
            alert '保存成功'
            @close_all_form()
        else
            alert '保存失败：' + data.error_message
    save_agent_config_error_callback: ->
        console.log 'save_plugin_config_error_callback'
    actions:
        show_resource_form: (res)->
            @close_all_form()
            @set 'current_resource', res
            @load_templates res
        close_resource_form: ->
            @set 'show_resource_form', false
        save_resource: ->
            console.log @get 'resource_name'
            console.log @get 'resource_desc'
            attrs = []
            @get('attributes').forEach (attr) ->
                attr.value = @.$('#res_attr_' + attr.id).val()
                nattr = 
                    'name': attr.name
                    'value': @.$('#res_attr_' + attr.id).val()
                attrs.pushObject nattr

            App.ajax.send
                name: 'wizard.step5.save_new_resource'
                sender: @
                data:
                    req_data: 
                        'tid': @get('template').id
                        'pid': if @get('current_resource') then @get('current_resource').id else 0
                        'name': @get 'resource_name'
                        'description': @get 'resource_desc'
                        'attributes': attrs
                success: 'save_resource_success'
                error: 'save_resource_error_callback'
        show_plugin_config: (res)->
            @set 'current_resource', res
            console.log @get 'current_resource'
            @close_all_form()
            @set 'show_plugin_config', true
        close_plugin_config: ->
            @set 'show_plugin_config', false
        save_plugin_config: ->
            console.log @get 'current_resource'
            res = @get 'current_resource'
            App.ajax.send
                name: 'wizard.step5.save_plugin_config'
                sender: @
                data: 
                    req_data:
                        rid: res.id
                        agentId: @get('agent').id
                success: 'save_plugin_config_success'
                error: 'save_plugin_config_error_callback'
        show_agent_config: (res)->
            @set 'current_resource', res
            @close_all_form()
            @load_agents()
        close_agent_config: ->
            @set 'show_agent_config', false
        save_agent_config: ->
            res = @get 'current_resource'
            console.log res
            App.ajax.send
                name: 'wizard.step5.save_plugin_config'
                sender: @
                data:
                    'rid': res.id
                    'req_data':
                        rid: res.id
                        agentId: @get('agent').id
                success: 'save_agent_config_success'
                error: 'save_agent_config_error_callback'
        remove_resource: (res)->
            @remove_resource res
        show_child: (resource) ->
            @close_all_form()
            @load_resource_children resource
    # actions:
    #     prev: ->
    #         @get('controllers.installer').setCurrentStep(4, false)
    #         @get('controllers.installer').send('gotoStep4')
    #     next: ->
    #         @get('controllers.installer').setCurrentStep(6, false)
    #         @get('controllers.installer').clear_install_options()
    #         @get('controllers.installer').send('gotoStep6')