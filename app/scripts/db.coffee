App.db = {}

InitialData = 
    'app':
        'loginName': ''
    'Installer': {}

if typeof Storage != 'undefined'
    Storage.prototype.setObject = (key, value)->
        @setItem(key, JSON.stringify(value))

    Storage.prototype.getObject = (key) ->
        value = @getItem(key)
        value && JSON.parse(value)
else
    window.localStorage = {}
    localStorage.setItem = (key, val) ->
        @[key] = value
    localStorage.getItem = (key) ->
        @[key]
    window.localStorage.setObject = (key, value) ->
        @[key] = value
    window.localStorage.getObject = (key) ->
        @[key]

App.db.cleanUp = ->
    console.log 'TRACE: Entering db:cleanup funciton'
    App.db.data = InitialData
    localStorage.setObject('mooem', App.db.data)

# 登录再进行cleanUP
#if localStorage.getObject('mooem') == null
#    console.log 'doing a cleanup'
#    App.db.cleanUp()
console.log 'doing a cleanup'
App.db.cleanUp()

console.log App.db.data
console.log App.db.data['Installer']

App.db.get = (namespace, key) ->
    console.log 'TRACE: Entering db:get ' + key
    App.db.data = localStorage.getObject 'mooem'
    App.db.data[namespace][key]

App.db.set = (namespce, key, value) ->
    console.log 'TRACE: Entering db:set ' + key + '; value: ' + value
    App.db.data = localStorage.getObject 'mooem'
    App.db.data[namespace][key] = value
    localStorage.setObject 'mooem', App.db.data

App.db.setLocalStorage = ->
    localStorage.setObject 'mooem', App.db.data

App.db.setWizardCurrentStep = (wizardType, currentStep) ->
    console.log 'Trace: Entering db:setWizardCurrentStep function'
    App.db.data[wizardType.capitalize()].currentStep = currentStep
    localStorage.setObject('mooem', App.db.data)

App.db.getWizardCurrentStep = (wizardType) ->
    console.log 'Trace: Entering db:getWizardCurrentStep function for ', wizardType
    App.db.data = localStorage.getObject 'mooem'
    if App.db.data[wizardType.capitalize()]
        console.log 'get'
        console.log App.db.data[wizardType.capitalize()]
        return App.db.data[wizardType.capitalize()]
    return 0