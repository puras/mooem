App.InstallerStep10Controller = App.StepController.extend

    actions:
        finish: ->
            @get('controllers.installer').setCurrentStep(0)
            @transitionToRoute('index')