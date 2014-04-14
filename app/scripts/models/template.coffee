attr = DS.attr
App.Template = DS.Model.extend
    tid: DS.attr 'number'
    pid: DS.attr 'number'
    name: DS.attr 'string'
    plugin_type: attr 'number'
    description: DS.attr 'string'
    attributes: DS.hasMany 'attribute'
App.Attribute = DS.Model.extend
    tid: attr 'number'
    name: attr 'string'
    type: attr 'string'
    settable: attr 'number'
    required: attr 'number'
    description: attr 'string'
    logicalType: attr 'number'
    defaultValue: attr 'string'
    min: attr 'number'
    max: attr 'number'
    template: DS.belongsTo 'template'

App.TemplatePluginType = DS.Model.extend
    tid: attr 'number'
    type: 'number'
    saveTable: 'string'