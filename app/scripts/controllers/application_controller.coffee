App.ApplicationController = Ember.Controller.extend
    getInstallerCurrentStep: ->
        @getWizardCurrentStep('installer')
    getWizardCurrentStep: (wizardType) ->
        currentStep = App.db.getWizardCurrentStep wizardType
        if !currentStep
            currentStep = wizardType == 'installer' ? '0' : '1'
        currentStep