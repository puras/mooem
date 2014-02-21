var attr = DS.attr;
App.Template = DS.Model.extend({
    tid: attr('number'),
    pid: attr('number'),
    name: attr('string'),
    type: attr('number'),
    description: attr('string')
});