App.InstallerStep7Route = Ember.Route.extend
    beforeModel: ->
        controller = @controllerFor('installer')
        controller.setCurrentStep(7, false)
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