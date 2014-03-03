var App = window.App = Ember.Application.create({
    LOG_TRANSITIONS: true,
    LOG_VIEW_LOOKUPS: true,
    rootElement: '#wrapper'
});

require('scripts/messages.js');

require('scripts/controllers/wizard.js');
require('scripts/controllers/installer.js');
require('scripts/controllers/installer/*');
// require('scripts/controllers/*');
require('scripts/store');
require('scripts/models/*');
require('scripts/routes/*');
require('scripts/views/*');
require('scripts/router');