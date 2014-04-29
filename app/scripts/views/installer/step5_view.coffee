App.InstallerStep5View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        @get('controller').load_resources()

App.Step5ChildContainerView = Ember.ContainerView.extend
    resource: null
    tagName: 'tr'
    init: ->
        console.log @get 'resource'
        @set 'elementId', 'child_resource_' + @get('resource').id

App.Step5ChildResourceView = Ember.View.extend
    templateName: 'installer/step5_child_resource'
    tagName: 'td'
    parentResource: null
    resources: null

App.Step5ResourceFormView = Ember.View.extend
    templateName: 'installer/step5_add_resource'

App.Step5PluginConfigView = Ember.View.extend
    resource: null
    templateName: 'installer/step5_plugin_config'

    actions: 
        save_plugin_config: ->
            container = Ember.View.views['plugin_config_resource_' + @get('resource').id]
            views = container.toArray()
            flag = true
            plugins = []
            views.forEach (view) ->
                if not view.get('is_config')
                    flag = false
                else
                    plugins.pushObject view.get('plugin')
            if flag
                @get('controller').save_plugin_config @get('resource'), plugins
            else
                alert '请完成所有配置'

App.Step5AgentConfigView = Ember.View.extend
    templateName: 'installer/step5_agent_config'

App.Step5ResourceAttrText = Ember.TextField.extend
    attr: null
    classNames: ['form-control']
    init: ->
        # console.log @get('attr')
        @set 'elementId', 'res_attr_' + @get('attr').id
        @set 'value', @get('attr').defaultValue

App.Step5PluginConfigContainerView = Ember.ContainerView.extend
    resource: null
    plugins: null
    init: ->
        @set 'elementId', 'plugin_config_resource_' + @get('resource').id
    didInsertElement: ->
        self = @
        res = @get 'resource'
        @get('plugins').forEach (plugin) ->
            child = App.Step5PluginConfigFormView.create()
            child.set_plugin plugin
            child.set_resource res
            self.pushObject child
App.Step5PluginConfigFormView = Ember.View.extend
    resource: null
    plugin: null
    is_config: false
    templateName: 'installer/step5_plugin_config_form'
    set_plugin: (plugin) ->
        @set 'plugin', plugin
    set_resource: (res) ->
        @set 'resource', res

    actions: 
        save_plugin_config_form: ->
            plugin = @get('plugin')
            console.log plugin.name
            flag = true
            plugin.configs.forEach (conf) ->
                conf.value = @.$('#conf_' + conf.id).val()
                if not conf.value
                    flag = false
            @set 'is_config', flag

App.Step5PluginConfigText = Ember.TextField.extend
    conf: null
    classNames: ['form-control']
    init: ->
        @set 'elementId', 'conf_' + @get('conf').id
        # 如果配置中value有值，则显示其值，反之显示defaultValue的值
        @set 'value', @get('conf').value || @get('conf').defaultValue