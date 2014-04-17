urls = 
    'wizard.launch_boot':
        'real': '/boot'
        'type': 'POST'
        'format': (data) ->
            console.log data
            console.log data.boot_data
            return {
                async: false
                data: data.boot_data
            }
    'wizard.step7.boot':
        'real': '/boot/{boot_req_id}'
    'wizard.step7.is_hosts_registered':
        'real': '/boot/hosts'
    'wizard.step3.load_template_children':
        'real': '/templates/{pid}/children'
        'type': 'POST'
    'wizard.step4.load_template_children':
        'real': '/templates/{pid}/children'
        'type': 'POST'
    'wizard.step4.load_template_plugin_type':
        'real': '/templates/{tid}/plugin_type'
        'type': 'POST'
    'wizard.step4.load_index_list':
        'real': '/templates/{tid}/index_list'
        'type': 'POST'
    'wizard.step4.load_plugin_list':
        'real': '/templates/{tid}/plugin_list'
        'type': 'POST'
    'wizard.step4.load_plugin_by_type':
        'real': '/plugins/type/{type}'
    'wizard.step4.load_plugin_index_list':
        'real': '/plugins/{pid}/index_list'
    'wizard.step4.save_template_index_config':
        'real': '/templates/{tid}/save_index_config'
        'type': 'POST'
        'format': (data) ->
            {
                contentType: "application/json; charset=utf-8"
                data: JSON.stringify data.req_data
            }
    'wizard.step4.save_template_plugin_config':
        'real': '/templates/{tid}/save_plugin_config'
        'type': 'POST'
        'format': (data) ->
            {
                contentType: "application/json; charset=utf-8"
                data: JSON.stringify data.req_data
            }
    'wizard.step5.load_resource_children':
        'real': '/resources/{pid}/children'
        'type': 'POST'
    'wizard.step5.load_template_attribute':
        'real': '/templates/{tid}/attributes'
        'type': 'POST'
    'wizard.step5.save_new_resource':
        'real': '/resources'
        'type': 'POST'
        'format': (data) ->
            {
                contentType: 'application/json; charset=utf-8'
                data: JSON.stringify data.req_data
            }
    'wizard.step5.remove_resource':
        'real': '/resources/{rid}'
        'type': 'DELETE'
    'wizard.step5.load_agents':
        'real': '/agents'
        'type': 'GET'
    'wizard.step5.save_plugin_config':
        'real': '/resources/{rid}/plugin_config'
        'type': 'POST'
        'format': (data) ->
            data: data.req_data


format_url = (url, data) ->
    if !url then return null
    keys = url.match /\{\w+\}/g
    console.log keys
    keys = if keys == null then [] else keys
    if keys
        keys.forEach (key)->
            console.log key
            raw_key = key.substr 1, key.length - 2
            replace = null
            console.log raw_key
            console.log 'value->' + data[raw_key]
            console.log (data[raw_key] == undefined or data[raw_key] == null)
            # if !data || !data[raw_key]
            if !data || (data[raw_key] == undefined or data[raw_key] == null)
                replace = ''
            else
                replace = data[raw_key]
            url = url.replace new RegExp(key, 'g'), replace
            console.log url
    url
format_req = (data) ->
    console.log '00000000000000000000', data
    opt =
        type: this.type || 'GET'
        timeout: App.timeout
        dataType: 'json'
        statusCode: App.status_codes

    opt.url = App.api_prefix + format_url(this.real, data)
    console.log opt.url

    console.log 'yyyyyyyyyyyyyyyyyyyyy' if @format
    if @format
        jQuery.extend(opt, @format(data, opt))
    opt

ajax = Ember.Object.extend
    send: (config) ->
        console.warn '======================ajax======================\n', config.name, config.data

        if !config.sender
            console.warn 'Ajax sender should be defined!'
            return null

        if !urls[config.name]
            console.warn 'Invalid name provided!'
            return null
        
        params = {}

        if (config.data)
            jQuery.extend(params, config.data)

        opt = {}

        opt = format_req.call(urls[config.name], params)
        opt.context = this

        opt.beforeSend = (xhr) ->
            if config.beforeSend
                config.sender[config.beforeSend] opt, xhr, params
        opt.success = (data, text_status, xhr) ->
            console.log "TRACE: The url is: " + opt.url
            if config.success
                config.sender[config.success] data, opt, params
        opt.error = (req, ajax_options, error) ->
            if config.error
                config.sender[config.error] req, ajax_options, error, opt
            else
                @default_error_handler req, opt.url, opt.type
        opt.complete = ->
            if config.callback
                config.callback()

        console.log opt
        $.ajax(opt)

    modal_popup: null

    default_error_handler: (jq_xhr, url, method, show_status) ->
        method = method || 'GET'
        self = @
        console.log method
        api = ' received on ' + method + ' method for API: ' + url
        show_message = true
        try
            json = $.parseJSON jq_xhr.responseText
            message = json.message
        catch err

        if show_status == null
            show_status = 500
        if message == undefined
            show_message = false

        status_code = jq_xhr.status + ' status code'
        if jq_xhr.status == show_status && !this.modal_popup
            alert message


App.ajax = ajax.create({})