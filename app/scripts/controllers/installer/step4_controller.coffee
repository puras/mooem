App.InstallerStep4Controller = App.StepController.extend
    templates: null
    template: null
    parent_template: null
    show_config: false
    show_index_form: false
    show_plugin_form: false
    plugin_type: null
    save_table: null
    index_list: null
    plugin_list: null

    plugins: null
    plugin: null
    plugin_index_list: null

    pluginDidChange: (->
        if @get 'plugin'
            console.log @get 'plugin'
            App.ajax.send
                name: 'wizard.step4.load_plugin_index_list'
                sender: this
                data:
                    pid: @get('plugin').id
                success: 'load_plugin_index_list_success'
                error: 'load_plugin_index_list_error_callback'
        else
            @set 'plugin_index_list', null
    ).observes('plugin')

    monitors: null
    monitor_plugin: null
    monitor_pluginSelected: (->
        console.log 'monitor_pluginSelected'
    ).property('monitor_plugin')

    load_plugin_index_list_success: (data) ->
        # @set 'plugin_index_list', data.index_list
        console.log '1'
        pil = []
        self = @
        $.each data.index_list, (idx, index)->
            pi = App.Index.create
                id: index.id
                pluginId: index.pluginId
                kpi: index.kpi
                name: index.name
                alias: index.alias
                inTemplate: self.indexIndexOfTemplate(index.pluginId, index.id) != -1
            console.log pi
            pil.pushObject pi
        @set 'plugin_index_list', pil
    load_plugin_index_list_error_callback: ->
        console.log 'load_plugin_index_list_error_callback'

    indexIndexOfTemplate: (pid, iid) ->
        i = -1
        if @get('index_list')
            $.each @get('index_list'), (idx, index) ->
                if index.id == iid and index.pluginId == pid
                    i = idx
                    return false
        i

    is_collection: (->
        @set_form_disabled()
        flag = @get('plugin_type') != null and @get('plugin_type').toString() == '0'
        if flag and @get('template').get('plugin_type') != null and @get('template').get('plugin_type').toString() == @get('plugin_type').toString()
            @set 'plugin_list', null
            @load_index_list()
        flag
    ).property('plugin_type')

    is_monitor: (->
        @set_form_disabled()
        flag = @get('plugin_type') != null and @get('plugin_type').toString() == '1'
        if flag and @get('template').get('plugin_type') != null and @get('template').get('plugin_type').toString() == @get('plugin_type').toString()
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
            @get('template').set 'plugin_type', data.templatePluginType.pluginType
        else
            @set 'plugin_type', null
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

    load_plugin_by_index: ->
        App.ajax.send
            name: 'wizard.step4.load_plugin_by_type'
            sender: this
            data:
                type: 0
            success: 'load_plugin_by_index_success'
            error: 'load_plugin_by_index_error_callback'
    load_plugin_by_index_success: (data) ->
        @set 'plugins', data.plugins
        @set 'show_index_form', true
        @set 'plugin_index_list', []
    load_plugin_by_index_error_callback: ->
        console.log 'load_plugin_by_index_error_callback'

    load_plugin_by_monitor: ->
        App.ajax.send
            name: 'wizard.step4.load_plugin_by_type'
            sender: this
            data:
                type: 1
            success: 'load_plugin_by_monitor_success'
            error: 'load_plugin_by_monitor_error_callback'
    load_plugin_by_monitor_success: (data)->
        self = @
        @set 'plugin_list', [] if @get('plugin_list') is null
        @set 'monitors', []
        @set 'monitor_plugin', []
        $.each data.plugins, (idx, plugin) ->
            console.log plugin
            p = self.get('plugin_list').findProperty 'id', plugin.id
            console.log p
            console.log (not p)
            if not p
                self.get('monitors').pushObject plugin
        # @set 'monitors', data.plugins
        @set 'show_plugin_form', true
    load_plugin_by_monitor_error_callback: ->
        console.log 'load_plugin_by_monitor_error_callback'

    save_template_config: ->
        console.log 'save_template_config'
        t = @get 'template'
        plugin_type = @get 'plugin_type'
        index_list = @get 'index_list'
        plugin_list = @get 'plugin_list'
        console.log plugin_type
        if plugin_type.toString() == '0'
            req_data = 
                tid: t.id
                pluginType: plugin_type
                indexList: index_list
            console.log index_list
            App.ajax.send
                name: 'wizard.step4.save_template_index_config'
                sender: this
                data:
                    'tid': t.id
                    'req_data': req_data
                success: 'save_template_config_success'
                error: 'save_template_config_error_callback'
        else if plugin_type.toString() == '1'
            console.log 'templatePluginType'
            req_data = 
                tid: t.id
                pluginType: plugin_type
                pluginList: plugin_list
            App.ajax.send
                name: 'wizard.step4.save_template_plugin_config'
                sender: this
                data:
                    'tid': t.id
                    'req_data': req_data
                success: 'save_template_config_success'
                error: 'save_template_config_error_callback'
    save_template_config_success: (data) ->
        if data.info is 'SUCCESS'
            alert '保存成功'
        else
            alert '保存失败:' + data.error_message
    save_template_config_error_callback: ->
        console.log 'save_template_config_error_callback'
    actions:
        show_config: (template) ->
            @set 'template', template
            @load_plugin_type template
            @set 'show_config', true
        close_config: ->
            @set 'show_config', false
        save_config: ->
            @save_template_config()
        show_index_form: ->
            @load_plugin_by_index()
        close_index_form: ->
            @set 'show_index_form', false
        save_index: ->
            self = @
            $.each @get('plugin_index_list'), (idx, index) ->
                if index.inTemplate
                    isIn = self.indexIndexOfTemplate index.pluginId, index.id
                    if isIn == -1
                        if self.get('index_list') is null
                            self.set('index_list', [])
                        self.get('index_list').pushObject index
        remove_index: (index) ->
            tindex = @get('index_list').findProperty 'id', index.id
            @get('index_list').removeObject tindex
            self = @
            $.each @get('plugin_index_list'), (idx, index) ->
                index.set 'inTemplate', (self.indexIndexOfTemplate(index.pluginId, index.id) != -1)
        show_plugin_form: ->
            @load_plugin_by_monitor()
        close_plugin_form: ->
            @set 'show_plugin_form', false
        save_plugin: ->
            console.log 'test'
            self = @
            console.log @get('monitor_plugin')
            if @get('monitor_plugin')
                @set 'plugin_list', [] if @get('plugin_list') is null
                $.each @get('monitor_plugin'), (idx, plugin) ->
                    p = self.get('plugin_list').findProperty 'id', plugin.id
                    if not p
                        self.get('plugin_list').pushObject plugin
            @set 'show_plugin_form', false
        remove_plugin: (plugin) ->
            p = @get('plugin_list').findProperty 'id', plugin.id
            @get('plugin_list').removeObject p
            @set 'show_plugin_form', false
        show_child: (template) ->
            @load_template_children template
        click: ->
            console.log 'clickclick'
