App = window.App = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_VIEW_LOOKUPS: true
    rootElement: '#wrapper'

App.ApplicationAdapter = DS.RESTAdapter.extend
    host: '/moofo'
    namespace: 'api/v1'

require 'app/config/i18n'
require 'app/config/config'
require 'app/controllers/application_controller'

require 'app/routes/*'