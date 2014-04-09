App.InstallerStep4Controller = App.StepController.extend
    templates: null
    template: null
    parent_template: null
    show_config: true
    show_index_form: false
    show_plugin_form: false
    plugin_type: null

    is_collection: (->
        @set_form_disabled()
        @get('plugin_type') == 'collection'
    ).property('plugin_type')

    is_monitor: (->
        @set_form_disabled()
        @get('plugin_type') == 'monitor'
    ).property('plugin_type')

    is_show_index_form: (->
        @get('is_collection') and @get 'show_index_form'
    ).property('plugin_type', 'show_index_form')

    is_show_plugin_form: (->
        @get('is_monitor') and @get 'show_plugin_form'
    ).property('plugin_type', 'show_plugin_form')

    set_form_disabled: ->
        @set 'show_index_form', false
        @set 'show_plugin_form', false

    has_parent: (parent) ->
        if parent != null and (parent.toString().indexOf('Step3ChildContainerView') != -1 or parent.toString().indexOf('Step3ChildTemplateView') != -1)
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
            name: 'wizard.step3.load_template_children'
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
        child = container.createChildView App.Step3ChildTemplateView
        child.set 'parentTemp', template
        child.set 'temps', data.templates
        container.pushObject child

    load_child_templates_error_callback: ->
        console.log 'load_child_templates_error_callback' 

    actions:
        show_config: (template) ->
            @set 'template', template
            @set 'show_config', true
        save_config: ->
            console.log 'save config in controller'
        show_index_form: ->
            @set 'show_index_form', true
        save_index: ->
            @set 'show_index_form', false
        show_plugin_form: ->
            @set 'show_plugin_form', true
        save_plugin: ->
            @set 'show_plugin_form', false
        show_child: (template) ->
            @load_template_children template
