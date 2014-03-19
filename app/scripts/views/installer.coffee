App.InstallerView = Ember.View.extend
    templateName: 'installer'

    is_step0_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 0).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step1_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 1).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step2_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 2).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step3_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 3).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step4_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 4).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step5_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 5).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step6_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 6).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step7_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 7).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step8_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 8).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step9_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 9).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()
    is_step10_disabled: (->
        @get('controller.is_step_disabled').findBy('step', 10).get('value')
    ).property('controller.is_step_disabled.@each.value').cacheable()