App.WizardController = Ember.Controller.extend({
    currentStep: function() {
        return 0;
    }.property(),
    isStep0: function() {
        return this.get('currentStep') == 0;
    }.property('currentStep'),
    isStep1: function() {
        return false;
    }.property('currentStep'),
    isStep2: function() {
        return false;
    }.property('currentStep'),
    isStep3: function() {
        return false;
    }.property('currentStep'),
    isStep4: function() {
        return false;
    }.property('currentStep'),
    isStep5: function() {
        return false;
    }.property('currentStep'),
    isStep6: function() {
        return false;
    }.property('currentStep'),

    gotoStep: function(step) {
        // this.send('gotoStep' + step);
        this.transitionToRoute('/installer/step' + step);
    },
    actions: {
        gotoStep0: function() {
            this.gotoStep(0);
        },
        gotoStep1: function() {
            this.gotoStep(1);
        },
        gotoStep2: function() {
            this.gotoStep(2);
        },
        gotoStep3: function() {
            this.gotoStep(3);
        },
        gotoStep4: function() {
            this.gotoStep(4);
        },
        gotoStep5: function() {
            this.gotoStep(5);
        },
        gotoStep6: function() {
            this.gotoStep(6);
        },

    }
});