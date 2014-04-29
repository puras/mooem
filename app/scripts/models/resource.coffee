attr = DS.attr
App.Resource = DS.Model.extend
    pid: attr 'number'
    tid: attr 'number'
    name: attr 'string'

App.ResourcePluginRelation = Ember.Object.extend
    id: ''
    address: ''
    plugin_name: ''
    is_checked: false
    deploy_status: 'FAILED'
    deploy_log: null

    is_deploy_done: (->
        switch @get 'deploy_status'
            when 'DONE', 'FAILED' then true
            when 'PENDING', 'RUNNING' then false
            else false
    ).property('deploy_status')

    deploy_bar_color: (->
        switch @get 'deploy_status'
            when 'DONE' then 'progress-bar-success'
            when 'FAILED' then 'progress-bar-danger'
            when 'PENDING', 'RUNNING' then ''
            else ''
    ).property('deploy_status')

    deploy_status_for_display: (->
        switch @get 'deploy_status'
            when 'PENDING' then 'Preparing'
            when 'FAILED' then 'Failed'
            when 'RUNNING' then 'Deploying'
            when 'DONE' then 'Success'
            else 'None'
    ).property('deploy_status')

    deploy_status_color: (->
        switch @get 'deploy_status'
            when 'DONE' then 'text-success'
            when 'FAILED' then 'text-error'
            when 'PENDING', 'RUNNING' then 'text-info'
            else 'text-info'
    ).property('boot_status')