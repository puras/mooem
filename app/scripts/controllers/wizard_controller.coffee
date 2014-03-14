App.WizardController = Ember.Controller.extend
    isStepDisabled: null
    boot_req_id: null
    init: ->
        @set 'isStepDisabled', []
        @get('isStepDisabled').pushObject(
            Ember.Object.create
                step: 1
                value: false
        )
        @get('isStepDisabled').pushObject(
            Ember.Object.create
                step: step
                value: true
        ) for step in [2..@get('totalSteps') ]

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
    isStep7: ( ->
        @get('currentStep') == 7
    ).property('currentStep')
    isStep8: ( ->
        @get('currentStep') == 8
    ).property('currentStep')
    isStep9: ( ->
        @get('currentStep') == 9
    ).property('currentStep')
    isStep10: ( ->
        @get('currentStep') == 10
    ).property('currentStep')

    gotoStep: (step) ->
        @transitionToRoute('/installer/step' + step)


    clear_install_options: ->
        install_options = jQuery.extend({}, @get('install_options_template'))
        @set('content.install_options', install_options)

    install_options_template:
        host_ips: '10.10.129.245\n10.10.129.244\n10.10.129.243'
        ssh_key: ''
        ssh_user: 'puras'
        req_id: null

    launch_boot: (boot_data) ->
        App.ajax.send
            name: 'wizard.launch_boot'
            sender: this
            data:
                'boot_data': boot_data
            success: 'launch_boot_success_callback'
            error: 'launch_boot_error_callback'
        @get('boot_req_id')
    launch_boot_success_callback: (data)->
        console.log 'TRACE: POST bootstrap succeeded'
        console.log '---->', data.reqId
        @set('boot_req_id', data.reqId)

    launch_boot_error_callback: ->
        console.log 'ERROR: POST bootstrap failed'
        alert 'Bootstrap call failed. Please try again.'

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
        gotoStep7: ->
            @gotoStep(7)
        gotoStep8: ->
            @gotoStep(8)
        gotoStep9: ->
            @gotoStep(9)
        gotoStep10: ->
            @gotoStep(10)