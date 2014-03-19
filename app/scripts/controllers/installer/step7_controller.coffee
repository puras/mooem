App.InstallerStep7Controller = Ember.Controller.extend
    needs: ['installer']
    hosts:[]
    boot_hosts: []
    content: (->
        @get('controllers.installer.content')
    ).property('controllers.installer.content')
    is_loaded: false
    num_polls: 0
    boot_is_stop: false
    is_submit_disabled: true

    load_step: ->
        console.log 'TRACE: Loading step7: Confirm Hosts'
        @set('is_loaded', false)
        @clear_step()
        @load_hosts()

    clear_step: ->
        @set 'boot_is_stop', false
        @set 'hosts', []
        @get('boot_hosts').clear()
        @set 'is_submit_disabled', true

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
        @set('is_loaded', true)

    navigate_step: (->
        if @get('is_loaded')
            console.log 'is_loaded -- true'
            @start_boot()
        else
            console.log 'is_loaded -- false'
    ).observes('is_loaded')

    start_boot: ->
        @set('num_polls', 0)
        @set('boot_hosts', @get('hosts'))
        @get('boot_hosts').setEach 'boot_status', 'PENDING'
        @do_boot()

    do_boot: ->
        if @get('boot_is_stop')
            return

        @set('num_polls', @get('num_polls') + 1)

        App.ajax.send
            name: 'wizard.step7.boot'
            sender: @
            data:
                boot_req_id: @get('content.install_options.req_id')
                num_polls: @get('num_polls')
            success: 'do_boot_success_callback'
        .retry
            times: App.max_retries
            timeout: App.timeout
        .then(
            null, 
            ->
                #// App.showReloadPopup()
                console.log('Boot failed')
        )

    do_boot_success_callback: (data)->
        self = @
        polling_interval = 3000
        console.log data.hostsStatus is null
        if data.hostsStatus is undefined or data.hostsStatus == null
            console.log 'Invalid response, setting timeout'
            window.setTimeout (->
                self.do_boot()), polling_interval
        else
            if data.hostsStatus not instanceof Array
                data.hostsStatus = [data.hostsStatus]

            console.log "TRACE: In success function for the GET bootstrap call"

            keep_polling = @parse_host_info data.hostsStatus

            if data.status == 'ERROR' or data.hostsStatus.length != @get('boot_hosts').length
                hosts = @get('boot_hosts')
                for host in hosts
                    is_valid_host = data.hostsStatus.someProperty 'hostName', host.name
                    if host.boot_status isnt 'REGISTERED'
                        if not is_valid_host
                            host.set 'boot_status', 'FAILED'
                            host.set 'boot_log', 'installer.step3.hosts.bootLog.failed'

            if data.status == 'ERROR' or data.hostsStatus.someProperty('status', 'DONE') || data.hostsStatus.someProperty 'status', 'FAILED'
                @stop_boot()

            if keep_polling
                window.setTimeout (->
                    self.do_boot()
                ), polling_interval

    parse_host_info: (hosts_status_from_server) ->
        console.log hosts_status_from_server
        hosts_status_from_server.forEach ((host_status) ->
            host = @get('boot_hosts').findProperty 'name', host_status.hostName
            
            if host and not ['DONE', 'FAILED'].contains host.boot_status
                host.set 'boot_status', host_status.status
                host.set 'boot_log', host_status.log
        ), this
        @get('boot_hosts').length isnt 0 and @get('boot_hosts').someProperty 'boot_status', 'RUNNING'

    stop_boot: ->
        is_submit_disabled = not @get('boot_hosts').someProperty 'boot_status', 'DONE'
        is_retry_disabled = not @get('boot_hosts').someProperty 'boot_status', 'FAILED'
        console.log is_submit_disabled
        console.log is_retry_disabled
        @get('boot_hosts').forEach (host) ->
            console.log host.name + '----' + host.boot_status


    start_reg: ->
        if @get('reg_started_at') is null
            @set('reg_started_at', new Date().getTime())
            console.log 'Registration started at ' + @get('reg_started_at')
            @is_host_registered()

    is_host_registered: ->
        if @get('boot_is_stop')
            return
        App.ajax.send
            name: 'wizard.step7.is_hosts_registered'
            sender: this
            success: 'is_hosts_registered_success_callback'
        .retry
            times: App.max_retries
            timeout: App.timeout
        .then(
            null, ->
            #App.showReloadPopup()
            console.log 'Error: Getting registered host information from the server'
        )
    is_hosts_registered_success_callback: (data) ->
        console.log data

    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(6, false)
            @get('controllers.installer').send('gotoStep6')
        next: ->
            @get('controllers.installer').setCurrentStep(8, false)
            @get('controllers.installer').send('gotoStep8')

        host_log_popup: (host) ->
            console.log host
            console.log host.name
            console.log 'host_log popup'
            App.ModalPopup.show
                header: '111'
                secondary: null