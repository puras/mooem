App.InstallerStep0Controller = Ember.Controller.extend({
    actions: {
        submit: function() {
            console.log('test');
            this.send('next');
        },
        next: function() {
            console.log('test');
            this.transitionToRoute('/installer/step1');
        }
    }
});