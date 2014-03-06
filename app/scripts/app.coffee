App = window.App = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_VIEW_LOOKUPS: true
    rootElement: '#wrapper'

require('scripts/messages')
require('scripts/db')

require('scripts/controllers/application_controller')
require('scripts/controllers/wizard_controller')
require('scripts/controllers/installer_controller')
require('scripts/controllers/**/*')
require('scripts/routes/*')
require('scripts/views/*')
require('scripts/views/**/*')
require('scripts/router')