App.InstallerStep3Controller = App.StepController.extend
    templates: []
    show_upload: true
    show_template: false
    template: null
    parent_template: null

    is_submit_disabled: (->
        @get('templates').length == 0
    ).property('templates')

    has_parent: (parent) ->
        if parent != null and (parent.toString().indexOf('Step3ChildContainerView') != -1 or parent.toString().indexOf('Step3ChildTemplateView') != -1)
            true
        else
            false
    child_index_of: (arr, obj) ->
        idx = -1
        $.each arr, (i, o) ->
            if o.target == obj
                idx = i
                return
        idx
    load_template_children: (template)->
        console.log 'load_template_children'
        @set 'parent_template', template
        App.ajax.send
            name: 'wizard.step3.load_template_children'
            sender: this
            data:
                pid: template.id
            success: 'load_child_templates_success'
            error: 'load_child_templates_error_callback'
    load_child_templates_success: (data)->
        template = @get 'parent_template'
        # container = Ember.View.views['child_template_' + template.get('id')]
        container = Ember.View.views['child_template_' + template.id]
        cons = Ember.View.views;
        arr = []
        for con_str of cons
            if con_str.toString().indexOf('child_template_') == 0
                con = Ember.View.views[con_str]
                if con == container
                    arr.push
                        target: con
                        flag: true
                    con_parent = con
                    while @has_parent con_parent
                        con_parent = con_parent.get 'parentView'
                        if @child_index_of(arr, con_parent) != -1
                            idx = @child_index_of(arr, con_parent)
                            arr[idx] = 
                                target: con_parent,
                                flag: true
                        else
                            arr.push
                                target: con_parent
                                flag: true
                else
                    if @child_index_of(arr, con) == -1
                        arr.push
                            target: con
                            flag: false
        for con in arr
            if !con.flag
                con.target.removeAllChildren()
                $('#' + con.target.elementId).empty()
        child = container.createChildView App.Step3ChildTemplateView
        child.set 'parentTemp', template
        child.set 'temps', data.templates
        container.pushObject child

    load_child_templates_error_callback: ->
        console.log 'load_child_templates_error_callback'
    actions:
        load_templates: ->
            self = @
            console.log @store.find('template')
            @store.find('template').then (ts)->
                temps = ts.filter (t) ->
                    t.get('pid') == 0
                self.set 'templates', temps
        remove_template: (template) ->
            if @get('template') isnt null and template.get('id') == @get('template').get('id')
                @set 'show_template', false
            template.deleteRecord()
            self = @
            template.save().then ->
                console.log 'yes'
                self.set 'templates', self.store.all('template').filter (item, index, self)->
                    item.get('pid') == 0
                # 如果模板列表为空，则显示上传界面
                if self.get('templates').length == 0
                    self.set 'show_upload', true
                    self.set 'show_template', false
            , ->
                console.log 'no'
                self.set 'templates', self.store.all('template').toArray()
        show_upload: ->
            @set 'show_upload', true
            @set 'show_template', false
        show_template: (template) ->
            # t = @store.find 'template', template.id
            self = @
            @store.find 'template', template.id
                .then (model) ->
                    console.log model
                    self.set 'show_upload', false
                    self.set 'show_template', true
                    self.set 'template', model
                    model.reload()
                    # @set 'show_upload', false
                    # @set 'show_template', true
                    # @set 'template', template
                    # template.reload()
        show_child: (template) ->
            @load_template_children template