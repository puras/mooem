App.InstallerController = App.WizardController.extend
    name: 'installerController'
    total_steps: 11

    content: Ember.Object.create
        hosts: null
        install_options: null
        controller_name: 'installerController'

    init: ->
        @_super()
        @get('is_step_disabled').setEach 'value', true
        @get('is_step_disabled').pushObject(
            Ember.Object.create
                step: 0
                value: false
        )