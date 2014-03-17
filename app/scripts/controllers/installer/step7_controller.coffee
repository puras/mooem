App.InstallerStep7Controller = Ember.Controller.extend
    needs: ['installer']
    hosts:[]
    content: (->
        @get('controllers.installer.content')
    ).property('controllers.installer.content')

    load_step: ->
        console.log 'TRACE: Loading step7: Confirm Hosts'

        @.load_hosts()

    load_hosts: ->
        console.log @get('content.hosts')
        hosts_info = @get('content.hosts')
        hosts = []
        console.log hosts_info['10.10.129.245'].name
        console.log hosts_info
        for key, val of hosts_info
            host_info = App.HostInfo.create
                name: val.name
                boot_status: val.boot_status
                is_checked: true
            hosts.pushObject host_info
        @set('hosts', hosts)

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep6')
        next: ->
            @get('controllers.installer').send('gotoStep8')

        host_log_popup: (host) ->
            console.log host
            console.log host.name
            console.log 'host_log popup'
            App.ModalPopup.show
                header: '111'
                secondary: null