var Mooem = window.Mooem = Ember.Application.create({
    LOG_TRANSITIONS: true
});

require('scripts/controllers/*');
require('scripts/store');
require('scripts/models/*');
require('scripts/routes/*');
require('scripts/views/*');
require('scripts/router');