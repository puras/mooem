App.HostInfo = Ember.Object.extend
    element_id: 'host'
    name: ''
    is_checked: true
    boot_status: 'PENDING'
    boot_log: null

    boot_status_for_display: (->
        switch @get('boot_status')
            when 'PENDING' then 'Preparing'
            when 'FAILED' then 'Failed'
            when 'RUNNING' then 'Installing'
            when 'DONE' then 'Success'
            else 'Registering'
    ).property('boot_status')

    boot_bar_color: (->
        switch @get('boot_status')
            when 'DONE' then 'progress-bar-success'
            when 'FAILED' then 'progress-bar-danger'
            when 'PENDING', 'RUNNING' then ''
            else ''
    ).property('boot_status')

    boot_status_color: (->
        switch @get('boot_status')
            when 'DONE' then 'text-success'
            when 'FAILED' then 'text-error'
            when 'PENDING', 'RUNNING' then 'text-info'
            else 'text-info'
    ).property('boot_status')

    is_boot_done: (->
        switch @get('boot_status')
            when 'DONE', 'FAILED' then true
            when 'PENDING', 'RUNNING' then false
            else false
    ).property('boot_status')