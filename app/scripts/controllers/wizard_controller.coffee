App.WizardController = Ember.Controller.extend
    isStepDisabled: null
    init: ->
        @set 'isStepDisabled', []
        @get('isStepDisabled').pushObject(
            Ember.Object.create
                step: 1
                value: false
        )
        console.log @get('totalSteps')
        @get('isStepDisabled').pushObject(
            Ember.Object.create
                step: step
                value: true
        ) for step in [2..@get('totalSteps') ]

        console.log @get('isStepDisabled')

    currentStep: (->
        console.log 'In currentStep function'
        console.log App.db.getWizardCurrentStep(@get('name').substr(0, @get('name').length - 10))
        App.db.getWizardCurrentStep(@get('name').substr(0, @get('name').length - 10))
    ).property()

    setCurrentStep: (currentStep, completed) ->
        console.log 'In Set currentStep function'
        App.db.setWizardCurrentStep(@get('name').substr(0, @get('name').length - 10), currentStep, completed)
        @set('currentStep', currentStep)

    isStep0: ( ->
        @get('currentStep') == 0
    ).property('currentStep')
    isStep1: ( ->
        @get('currentStep') == 1
    ).property('currentStep')
    isStep2: ( ->
        @get('currentStep') == 2
    ).property('currentStep')
    isStep3: ( ->
        @get('currentStep') == 3
    ).property('currentStep')
    isStep4: ( ->
        @get('currentStep') == 4
    ).property('currentStep')
    isStep5: ( ->
        @get('currentStep') == 5
    ).property('currentStep')
    isStep6: ( ->
        @get('currentStep') == 6
    ).property('currentStep')

    gotoStep: (step) ->
        @transitionToRoute('/installer/step' + step)
    actions:
        gotoStep0: ->
            @gotoStep(0)
        gotoStep1: ->
            @gotoStep(1)
        gotoStep2: ->
            @gotoStep(2)
        gotoStep3: ->
            @gotoStep(3)
        gotoStep4: ->
            @gotoStep(4)
        gotoStep5: ->
            @gotoStep(5)
        gotoStep6: ->
            @gotoStep(6)