App.StepController = Ember.Controller.extend
    needs: ['installer']
    step: (->
        @get('controllers.installer').get_step @
    ).property()
    prev_step: (->
        @get('controllers.installer').prev_step @get('step')
    ).property('step')
    next_step: (->
        @get('controllers.installer').next_step @get('step')
    ).property('step')
    
    actions:
        prev: ->
            @get('controllers.installer').setCurrentStep(@get('prev_step'), false)
            @get('controllers.installer').send('gotoStep' + @get('prev_step'))
        next: ->
            console.log @get('next_step')
            @get('controllers.installer').setCurrentStep(@get('next_step'), false)
            @get('controllers.installer').send('gotoStep' + @get('next_step'))