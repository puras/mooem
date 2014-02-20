Mooem.ApplicationRoute = Ember.Route.extend({
    model: function() {
        return ['red', 'yellow', 'blue', 'green', 'black', 'white'];
    }, 
    setupController: function(controller, model) {
        controller.set('model', model);
    }
});