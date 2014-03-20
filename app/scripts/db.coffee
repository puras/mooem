App.db = {}

InitialData = 
    'app':
        'loginName': ''
    'Installer': {}
###
在不支持localStorage的浏览器下可能会有问题，未测试
console.log typeof Storage == 'undefined'
if typeof Storage == 'undefined'
    window.localStorage = {}
    localStorage = {}
    localStorage.setItem = (key, val) ->
        @[key] = val
    localStorage.getItem = (key) ->
        @[key]
###

App.db.setObject = (key, value) ->
    localStorage.setItem(key, JSON.stringify(value))
App.db.getObject = (key) ->
    value = localStorage.getItem(key)
    value && JSON.parse(value)

App.db.cleanUp = ->
    console.log 'TRACE: Entering db:cleanup funciton'
    App.db.data = InitialData
    App.db.setObject('mooem', App.db.data)

# 登录再进行cleanUP
#if localStorage.getObject('mooem') == null
#    console.log 'doing a cleanup'
#    App.db.cleanUp()
console.log 'doing a cleanup'
App.db.cleanUp()

App.db.setWizardCurrentStep = (wizardType, currentStep) ->
    console.log 'Trace: Entering db:setWizardCurrentStep function'
    App.db.data = App.db.getObject 'mooem'
    App.db.data[wizardType.capitalize()].currentStep = currentStep
    App.db.setObject('mooem', App.db.data)

App.db.getWizardCurrentStep = (wizardType) ->
    console.log 'Trace: Entering db:getWizardCurrentStep function for ', wizardType
    App.db.data = App.db.getObject 'mooem'
    if App.db.data[wizardType.capitalize()]
        return App.db.data[wizardType.capitalize()].currentStep
    return 0