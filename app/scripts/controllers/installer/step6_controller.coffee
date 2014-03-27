App.InstallerStep6Controller = App.StepController.extend
    host_name_arr: []
    is_pattern: false
    boot_request_id: null
    has_submitted: false
    inputted_again_host_names: []
    needs: ['installer']

    host_names: (->
        @get('content.install_options.host_names')
    ).property('content.install_options.host_names')

    # actions:
    #     prev: ->
    #         @get('controllers.installer').setCurrentStep(5, false)
    #         @get('controllers.installer').send('gotoStep1')
    #     next: ->
    #         @get('controllers.installer').setCurrentStep(7, false)
    #         @get('controllers.installer').send('gotoStep3')