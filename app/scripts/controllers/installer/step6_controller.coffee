App.InstallerStep6Controller = Ember.Controller.extend
    needs: ['installer']
    has_submitted: false
    hosts_error: null
    host_ip_arr: []
    again_host_ips: []
    content: (->
        @get('controllers.installer.content')
    ).property('controllers.installer.content')

    host_ips: (->
        @get('content.install_options.host_ips')
    ).property('content.install_options.host_ips')

    ssh_key: (->
        @get('content.install_options.ssh_key')
    ).property('content.install_options.ssh_key')
    ssh_key_error: (->
        if @get('has_submitted') && @get('ssh_key').trim() == ''
            'SSH Private Key is required'
    ).property('ssh_key', 'has_submitted')

    set_ssh_key: (ssh_key) ->
        @set('content.install_options.ssh_key', ssh_key)

    ssh_user: (->
        @get('content.install_options.ssh_user')
    ).property('content.install_options.ssh_user')
    ssh_user_error: (->
        if @get('ssh_user').trim() == ''
            'User name is required'
    ).property('ssh_user')

    check_host_error: ->
        if @get('has_submitted') && @get('host_ips').trim() == ''
            @set('hosts_error', 'You must specify at least one host name')
        else
            @set('hosts_error', null)
    # 提交后，再次更新host时触发本检测
    check_host_after_submit_handler: ( ->
        if @get('has_submitted')
            @check_host_error()
    ).observes('has_submitted', 'host_ips')

    is_submit_disabled: (->
        (@get('hosts_error') || @get('ssh_key_error') || @get('ssh_user_error'))
    ).property('hosts_error', 'ssh_key', 'ssh_user')

    update_host_ip_arr: ->
        @host_ip_arr = @get('host_ips').trim().split(new RegExp('\\s+', 'g'))
        console.log @host_ip_arr
        # TODO 在这里应该验证输入的IP列表是否有效
    is_all_host_ips_valid: ->
        true

    get_host_info: ->
        host_ip_arr = @get('host_ip_arr')
        host_info = {}
        host_ip_arr.forEach (host)->
            host_info[host] = 
                name: host
                boot_status: 'PENDING'
        host_info
    save_hosts: ->
        @set('content.hosts', @get_host_info())
        @get('controllers.installer').send('gotoStep7')

    proceed_next: (warning_confirmed) ->
        ###
        if @is_all_host_ips_valid() != true && !warning_confirmed
            @warning_popup()
            return false
        ###
        boot_data =
            'verbose': true
            'sshKey': @get('ssh_key')
            'hosts': @get('host_ip_arr')
            'user': @get('ssh_user')

        # TODO 暂时不向后台请求
        # req_id = @get('controllers.installer').launch_boot(boot_data)
        req_id = 1
        console.log '--------------->', typeof req_id
        
        if req_id == '0' || req_id == 0
            console.log 'Host Registration is currently in progress.  Please try again later.'
            alert 'Host Registration is currently in progress.  Please try again later.'
        else
            @set('content.install_options.req_id', req_id)
            @save_hosts()

    actions:
        prev: ->
            @get('controllers.installer').send('gotoStep5')
        next: ->
            if @get('is_submit_disabled')
                console.log('1')
                return false
            @set('has_submitted', true)

            @check_host_error()
            if (@get('hosts_error') || @get('ssh_key_error') || @get('ssh_user_error'))
                console.log 2
                return false

            @update_host_ip_arr()
            if !@host_ip_arr.length
                @set('hosts_error', 'installer.step2.hostName.error.already_installed')
                console.log 3
                return false

            @proceed_next()