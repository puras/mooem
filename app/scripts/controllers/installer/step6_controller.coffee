App.InstallerStep6Controller = Ember.Controller.extend
    needs: ['installer']
    has_submitted: false
    hosts_error: null
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
        console.log @get('ssh_key_error')
        console.log if (@get('hosts_error') || @get('ssh_key_error') || @get('ssh_user_error')) then 'yes' else 'no'
        (@get('hosts_error') || @get('ssh_key_error') || @get('ssh_user_error'))
    ).property('hosts_error', 'ssh_key', 'ssh_user')
    
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

            # @get('controllers.installer').send('gotoStep7')