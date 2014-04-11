App.InstallerStep4Controller = App.StepController.extend
    templates: null
    template: null
    parent_template: null
    show_config: true
    show_index_form: false
    show_plugin_form: false
    plugin_type: null
    save_table: null
    index_list: null
    plugin_list: null

    change_type: (->
        console.log 'change type'
    ).property('type')

    is_collection: (->
        @set_form_disabled()
        flag = @get('plugin_type') != null and @get('plugin_type').toString() == '0'
        if flag
            @set 'plugin_list', null
            @load_index_list()
        flag
    ).property('plugin_type')

    is_monitor: (->
        @set_form_disabled()
        flag = @get('plugin_type') != null and @get('plugin_type').toString() == '1'
        if flag
            @set 'index_list', null
            @load_plugin_list()
        flag
    ).property('plugin_type')

    is_show_index_form: (->
        console.log 'test'
        @get('is_collection') and @get 'show_index_form'
    ).property('plugin_type', 'show_index_form')

    is_show_plugin_form: (->
        @get('is_monitor') and @get 'show_plugin_form'
    ).property('plugin_type', 'show_plugin_form')

    set_form_disabled: ->
        @set 'show_index_form', false
        @set 'show_plugin_form', false

    has_parent: (parent) ->
        if parent != null and (parent.toString().indexOf('Step4ChildContainerView') != -1 or parent.toString().indexOf('Step4ChildTemplateView') != -1)
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

    load_template_children: (template) ->
        @set 'parent_template', template
        App.ajax.send
            name: 'wizard.step4.load_template_children'
            sender: this
            data:
                pid: template.id
            success: 'load_child_templates_success'
            error: 'load_child_templates_error_callback'
    load_child_templates_success: (data) ->
        template = @get 'parent_template'
        # container = Ember.View.views['child_template_' + template.get('id')]
        container = Ember.View.views['child_template_' + template.id]
        cons = Ember.View.views;
        arr = []
        for con_str of cons
            if con_str.toString().indexOf('child_template_') == 0
                con = Ember.View.views[con_str]
                if con == container
                    arr.push
                        target: con
                        flag: true
                    con_parent = con
                    while @has_parent con_parent
                        con_parent = con_parent.get 'parentView'
                        if @child_index_of(arr, con_parent) != -1
                            idx = @child_index_of(arr, con_parent)
                            arr[idx] = 
                                target: con_parent,
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
        child = container.createChildView App.Step4ChildTemplateView
        child.set 'parentTemp', template
        child.set 'temps', data.templates
        container.pushObject child

    load_child_templates_error_callback: ->
        console.log 'load_child_templates_error_callback' 

    load_plugin_type: (template) ->
        App.ajax.send
            name: 'wizard.step4.load_template_plugin_type'
            sender: this
            data:
                tid: template.id
            success: 'load_template_plugin_type_success'
            error: 'load_template_plugin_type_error_callback'
    load_template_plugin_type_success: (data) ->
        if data.templatePluginType
            @set 'plugin_type', data.templatePluginType.pluginType
            @set 'save_table', data.templatePluginType.saveTable
        else
            @set 'plugin_type', 0
            @set 'save_table', null
    load_template_plugin_type_error_callback: ->
        console.log 'load_template_plugin_type_error_callback'

    load_index_list: ->
        tid = @get('template').id
        App.ajax.send
            name: 'wizard.step4.load_index_list'
            sender: this
            data:
                tid: tid
            success: 'load_index_list_success'
            error: 'load_index_list_error_callback'
    load_index_list_success: (data) ->
        @set 'index_list', data.index_list
    load_index_list_error_callback: ->
        console.log 'load_index_list_error_callback'
    load_plugin_list: ->
        tid = @get('template').id
        App.ajax.send
            name: 'wizard.step4.load_plugin_list'
            sender: this
            data:
                tid: tid
            success: 'load_plugin_list_success'
            error: 'load_plugin_list_error_callback'
    load_plugin_list_success: (data)->
        @set 'plugin_list', data.plugin_list
    load_plugin_list_error_callback: ->
        console.log 'load_plugin_list_error_callback'

    load_plugin_by_type: (type)->
        console.log 'type------------------->' + type
        App.ajax.send
            name: 'wizard.step4.load_plugin_by_type'
            sender: this
            data:
                type: type
            success: 'load_plugin_by_type_success'
            error: 'load_plugin_by_type_error_callback'
    load_plugin_by_type_success: (data) ->
        @set 'plugins', data.plugins
        @set 'show_index_form', true
    load_plugin_by_type_error_callback: ->
        console.log 'load_plugin_by_type_error_callback'
    actions:
        show_config: (template) ->
            @set 'template', template
            @load_plugin_type template
            @set 'show_config', true
        save_config: ->
            console.log 'save config in controller'
        show_index_form: ->
            @load_plugin_by_type(0)
        save_index: ->
            @set 'show_index_form', false
        show_plugin_form: ->
            @set 'show_plugin_form', true
        save_plugin: ->
            @set 'show_plugin_form', false
        show_child: (template) ->
            @load_template_children template
        click: ->
            console.log 'clickclick'
