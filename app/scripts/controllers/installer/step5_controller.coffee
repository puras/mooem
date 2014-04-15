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

    # is_show_resource_form: (->
    #     console.log @get('show_resource_form')
    #     console.log @get('resources').length == 0
    #     @get('show_resource_form') or @get('resources').length == 0
    # ).property('show_resource_form', 'resources')

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
        @set 'templates', data.templates
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
        console.log data.resources
    load_resource_children_error_callback: ->
        console.log 'load_resource_children_error_callback'

    actions:
        show_resource_form: (res)->
            @close_all_form()
            @set 'show_resource_form', true
            @load_templates res
        close_resource_form: ->
            @set 'show_resource_form', false
        show_plugin_config: ->
            @close_all_form()
            @set 'show_plugin_config', true
        close_plugin_config: ->
            @set 'show_plugin_config', false
        show_agent_config: ->
            @close_all_form()
            @set 'show_agent_config', true
        close_agent_config: ->
            @set 'show_agent_config', false
        remove_resource: ->
            console.log 'remove resource'
        show_child: (resource) ->
            @load_resource_children resource
    # actions:
    #     prev: ->
    #         @get('controllers.installer').setCurrentStep(4, false)
    #         @get('controllers.installer').send('gotoStep4')
    #     next: ->
    #         @get('controllers.installer').setCurrentStep(6, false)
    #         @get('controllers.installer').clear_install_options()
    #         @get('controllers.installer').send('gotoStep6')