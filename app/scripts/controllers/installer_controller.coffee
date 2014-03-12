App.InstallerController = App.WizardController.extend
    name: 'installerController'
    totalSteps: 7

    content: Ember.Object.create
        hosts: null
        install_options: null
        controller_name: 'installerController'