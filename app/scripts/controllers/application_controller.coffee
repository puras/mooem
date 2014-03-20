App.ApplicationController = Ember.Controller.extend
    getInstallerCurrentStep: ->
        @getWizardCurrentStep('installer')
    getWizardCurrentStep: (wizardType) ->
        console.log 'application'
        currentStep = App.db.getWizardCurrentStep wizardType
        console.log 'current_step', currentStep
        if !currentStep
            currentStep = wizardType == 'installer' ? '0' : '1'
        console.log 'current_step', currentStep
        currentStep