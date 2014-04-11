App.InstallerStep4View = App.InstallerStepView.extend()

App.Step4ChildContainerView = Ember.ContainerView.extend
    temp: null
    tagName: 'tr'
    init: ->
        @set 'elementId', 'child_template_' + @get('temp').id

App.Step4ChildTemplateView = Ember.View.extend
    templateName: 'installer/step4_child_template'
    tagName: 'td'
    parentTemp: null
    temps: null

App.Step4TemplateConfigView = Ember.View.extend
    templateName: 'installer/step4_template_config'
    temp: null
    actions:
        save_config: ->
            console.log 'save_config'
        
        click: ->
            console.log 'clickclick'

App.Step4IndexListView = Ember.View.extend
    templateName: 'installer/step4_index_list'

App.Step4AddIndexView = Ember.View.extend
    templateName: 'installer/step4_add_index'

App.Step4PluginListView = Ember.View.extend
    templateName: 'installer/step4_plugin_list'

App.Step4AddPluginView = Ember.View.extend
    templateName: 'installer/step4_add_plugin'