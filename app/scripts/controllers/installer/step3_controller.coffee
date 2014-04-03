App.InstallerStep3Controller = App.StepController.extend
    templates: []

    is_submit_disabled: (->
        @get('templates').length == 0
    ).property('templates')

    actions:
        load_templates: ->
            self = @
            console.log @store.find('template')
            @store.find('template').then (ts)->
                temps = ts.map (t) ->
                    t
                self.set 'templates', temps
        remove_template: (template) ->
            template.deleteRecord()
            self = @
            template.save().then ->
                console.log 'yes'
                self.set 'templates', self.store.all('template').toArray()
            , ->
                console.log 'no'
                self.set 'templates', self.store.all('template').toArray()