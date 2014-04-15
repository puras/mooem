attr = DS.attr
App.Resource = DS.Model.extend
    pid: attr 'number'
    tid: attr 'number'
    name: attr 'string'