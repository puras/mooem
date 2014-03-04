App = window.App = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_VIEW_LOOKUPS: true
    rootElement: '#wrapper'

require('scripts/messages')
require('scripts/db')

require('scripts/controllers/wizard_controller')
require('scripts/controllers/installer_controller')
require('scripts/routes/*')
require('scripts/router')

App.db.data = App.Mooem