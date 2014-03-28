App = window.App = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_VIEW_LOOKUPS: true
    rootElement: '#wrapper'

App.ApplicationAdapter = DS.RESTAdapter.extend
    host: '/octopus'
    namespace: 'api/v1'

require('scripts/messages')
require('scripts/config')
require('scripts/status_codes')
require('scripts/ajax')
require('scripts/db')

require('scripts/controllers/application_controller')
require('scripts/controllers/wizard_controller')
require('scripts/controllers/installer_controller')
require('scripts/controllers/installer/step_controller')
require('scripts/controllers/**/*')
require('scripts/routes/installer/step_route')
require('scripts/routes/installer/installer_route')
require('scripts/routes/**/*')
require('scripts/models/*')
require('scripts/views/*')
require('scripts/views/**/*')
require('scripts/router')