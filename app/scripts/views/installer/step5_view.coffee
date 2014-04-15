App.InstallerStep5View = App.InstallerStepView.extend
    didInsertElement: ->
        @_super()
        @get('controller').load_resources()

App.Step5ChildContainerView = Ember.ContainerView.extend
    resource: null
    tagName: 'tr'
    init: ->
        @set 'elementId', 'child_resource_' + 1#@get('resource').id

App.Step5ChildResourceView = Ember.View.extend
    templateName: 'installer/step5_child_resource'
    tagName: 'td'
    parentResource: null
    resources: null

App.Step5ResourceFormView = Ember.View.extend
    templateName: 'installer/step5_add_resource'

App.Step5PluginConfigView = Ember.View.extend
    templateName: 'installer/step5_plugin_config'

App.Step5AgentConfigView = Ember.View.extend
    templateName: 'installer/step5_agent_config'