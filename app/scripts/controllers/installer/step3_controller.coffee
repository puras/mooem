App.InstallerStep3Controller = App.StepController.extend
    templates: []

    # load_template: ->
    #     console.log 'test'
    #     console.log @get('templates')

    # actions:
    #     add_templates: ->
    #         @set 'templates', @store.find 'template'
    #     prev: ->
    #         @get('controllers.installer').setCurrentStep(2, false)
    #         @get('controllers.installer').send('gotoStep2')
    #     next: ->
    #         # temp = @get('store').createRecord 'template',
    #         #     name: 'new Name' + @get('templates.length')
    #         #     description: 'new Description' + @get('templates.length')
    #         # temp.save().then(
    #         #     ->
    #         #         console.log 'save success'
    #         #     ,
    #         #     ->
    #         #         console.log 'save error'
    #         #         temp.deleteRecord()
    #         #         alert '保存失败'
    #         # )
    #         @get('controllers.installer').setCurrentStep(4, false)
    #         @get('controllers.installer').send('gotoStep4')