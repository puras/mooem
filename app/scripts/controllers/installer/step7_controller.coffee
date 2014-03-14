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

        ###
        // hosts_info.forEach (host) ->
        //     host_info = App.HostInfo.create
        //         name: host.name
        //         boot_status: host.boot_status
        //         is_checked: false
        //     hosts.pushObject(host)
        ###
        @set('hosts', hosts)

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep6')
        next: ->
            @get('controllers.installer').send('gotoStep8')