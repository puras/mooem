App.InstallerStep2Route = App.StepRoute.extend
    beforeModel: ->
        @_super()
        controller = @controllerFor('installer')
        controller.clear_install_options()

    setupController: (controller, model) ->
        hosts = {
            '10.10.129.243': 
                'name': '10.10.129.243'
                'boot_status': 'RUNNING'
            '10.10.129.244': 
                'name': '10.10.129.244'
                'boot_status': 'FAILED'
            '10.10.129.245': 
                'name': '10.10.129.245'
                'boot_status': 'REGISTERED'
        }
        controller.set('content.hosts', hosts)
        controller.set('content.install_options.req_id', 1)