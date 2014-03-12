App.InstallerStep2Controller = Ember.Controller.extend
    name: 'installerStep2Controller'
    host_name_arr: []
    is_pattern: false
    boot_request_id: null
    has_submitted: false
    inputted_again_host_names: []
    needs: ['installer']

    host_names: (->
        @get('content.install_options.host_names')
    ).property('content.install_options.host_names')

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep1')
        next: ->
            @get('controllers.installer').send('gotoStep3')