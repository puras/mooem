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

format_url = (url, data) ->
    if !url then return null
    keys = url.match /\{\w+\}/g
    keys = if keys == null then [] else keys
    if keys
        keys.forEach (key)->
            raw_key = key.substr 1, key.length - 2
            replace
            if !data || !data[raw_key]
                replace = ''
            else
                replace = data[raw_key]
            url = url.replace new RegExp(key, 'g'), replace
    url
format_req = (data) ->
    opt =
        type: this.type || 'GET'
        timeout: App.timeout
        dataType: 'json'
        statusCode: App.status_codes

    opt.url = App.api_prefix + format_url(this.real, data)

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
        api = ' received on ' + method ' method for API: ' + url
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