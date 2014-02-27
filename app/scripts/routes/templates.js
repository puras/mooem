App.TemplatesIndexRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('template');
    }, 
    setupController: function(controller, model) {
        controller.set('model', model);
    },
    beforeModel: function() {
        this.transitionTo('login');
    }
});
App.TemplateRoute = Ember.Route.extend({
    model: function(params) {
        return this.store.find('template', params.template_id);
    }
});
