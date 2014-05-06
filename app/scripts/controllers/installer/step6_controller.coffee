App.InstallerStep6Controller = App.StepController.extend
    relations: []
    is_loaded: false

    deploy_relas: []
    deploy_req_id: null

    load_data: ->
        App.ajax.send
            name: 'wizard.step6.load_resource_plugin_relation'
            sender: @
            success: 'load_resource_plugin_relation_success_callback'
            error: 'load_resource_plugin_relation_error_callback'
    load_resource_plugin_relation_success_callback: (data)->
        relations = []
        rela_data = []
        data.relations.forEach (rela) ->
            data = rela_data.findProperty 'host', rela.address
            if not data
                data = {
                    host: rela.address
                    plugins: []
                }
                rela_data.pushObject data
            data.plugins.pushObject rela.tarName
            relation = App.ResourcePluginRelation.create
                id: rela.id
                address: rela.address
                plugin_name: rela.tarName
                is_checked: true
            relations.pushObject relation
        @set 'relations', relations
        ssh_info = App.db.getSSHInfo()
        deploy_data = 
            'verbose': ssh_info.verbose
            'sshKey': ssh_info.ssh_key
            'user': ssh_info.ssh_user
            'data': rela_data
        console.log deploy_data
        # req_id = 
        @launch_deploy deploy_data
        # @set 'deploy_req_id', req_id
    load_resource_plugin_relation_error_callback: ->
        console.log 'load_resource_plugin_relation_error_callback'

    launch_deploy: (deploy_data) ->
        App.ajax.send
            name: 'wizard.launch_deploy'
            sender: @
            data:
                'deploy_data': deploy_data
            success: 'launch_deploy_success_callback'
            error: 'launch_deploy_error_callback'
        @get 'deploy_req_id'
    launch_deploy_success_callback: (data) ->
        console.log 'TRACE: POST deploy success.'
        console.log '---->', data.reqId
        @set 'deploy_req_id', data.reqId
        @load_step()
    launch_deploy_error_callback: ->
        console.log 'ERROR: POST deploy failed.'
        alert 'Deploy call failed. Please try again.'

    load_step: ->
        @set 'is_loaded', false
        @clear_step()
    clear_step: ->
        @set 'deploy_is_stop', false
        # @set 'relas', []
        @get('deploy_relas').clear()
        @set 'is_submit_disabled', true
        @set 'is_loaded', true

    navigate_step: (->
        if @get 'is_loaded'
            console.log 'is_loaded -- true'
            @start_deploy()
        else
            console.log 'is_loaded -- false'
    ).observes('is_loaded')

    start_deploy: ->
        @set 'num_polls', 0
        console.log @get 'relations'
        # @set 'deploy_relas', @get 'relations'
        @get('relations').setEach 'deploy_status', 'PENDING'
        @do_deploy()

    do_deploy: ->
        console.log 'do deploy'
        if @get 'deploy_is_stop'
            return

        @set 'num_polls', @get('num_polls') + 1

        App.ajax.send
            name: 'wizard.step6.deploy'
            sender: @
            data:
                deploy_req_id: @get 'deploy_req_id'
                num_polls: @get 'num_polls'
            success: 'do_deploy_success_callback'
        .retry
            times: App.max_retries
            timeout: App.timeout
        .then(
            null,
            ->
                console.log 'Deploy failed.'
        )
    do_deploy_success_callback: (data)->
        console.log 'do_deploy_success_callback'
        self = @
        polling_interval = 3000
        if data.pluginsStatus is undefined or data.pluginsStatus == null
            console.log 'Invalid response, setting timeout'
            window.setTimeout (->
                self.do_deploy()), polling_interval
        else
            if data.pluginsStatus not instanceof Array
                data.pluginsStatus = [data.pluginsStatus]

            console.log "TRACE: In success function for the GET deploy call"

            keep_polling = @parse_deploy_info data.pluginsStatus
            console.log keep_polling, '==========================='
            if data.status == 'ERROR' or data.pluginsStatus.length != @get('relations').length
                relas = @get 'relations'
                for rela in relas
                    is_valid_plugin = @get_plugin rela.address, rela.tar_name
                    if not is_valid_plugin
                        rela.set 'deploy_status', 'FAILED'
                        rela.set 'deploy_log', 'installer.step3.hosts.bootLog.failed'

            if data.status == 'ERROR' or data.pluginsStatus.someProperty('status', 'DONE') or data.pluginsStatus.someProperty('status', 'FAILED')
                @stop_deploy()

            if keep_polling
                window.setTimeout (->
                    self.do_deploy()
            ), polling_interval
    parse_deploy_info: (plugins_status_from_server) ->
        self = @
        plugins_status_from_server.forEach ((plugin_status) ->
            console.log plugin_status.hostName
            console.log plugin_status.tarName
            plugin = @get_plugin plugin_status.hostName, plugin_status.tarName
            console.log plugin
            if plugin and not ['DONE', 'FAILED'].contains plugin.deploy_status
                plugin.set 'deploy_status', plugin_status.status
                plugin.set 'deploy_log', plugin_status.log
        ), @
        @get('relations').length isnt 0 and @get('relations').someProperty 'deploy_status', 'RUNNING'

    get_plugin: (address, tar_name) ->
        plugin = null
        console.log address, '======================='
        console.log tar_name, '========================='
        @get('relations').forEach (rela) ->
            console.log rela.address, '----------------------'
            console.log rela.plugin_name, '------------------------'
            if rela.address is address and rela.plugin_name is tar_name
                plugin = rela
                return
        plugin
    stop_deploy: ->
        is_submit_disabled = not @get('relations').someProperty 'deploy_status', 'DONE'
        is_retry_disabled = not @get('relations').someProperty 'deploy_status', 'FAILED'
        @get('relations').forEach (rela) ->
            console.log rela.address + '------' + rela.deploy_status
    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(1, false)
            @get('controllers.installer').send('gotoStep' + 1)