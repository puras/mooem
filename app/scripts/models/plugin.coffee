App.Plugin = DS.Model.extend
    type: DS.attr 'string'
    tarName: DS.attr 'string'

App.Index = Ember.Object.extend
    id: null
    pluginId: null
    kpi: null
    name: null
    alias: null
    inTemplate: false