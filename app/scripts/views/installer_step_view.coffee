App.InstallerStepView = Ember.View.extend
    
    didInsertElement: ->
        $("[data-toggle=popover]").popover ({'placement': 'right', 'trigger': 'hover'})
        $("[data-toggle=popover]").on('remove', ->
            $(this).trigger('mouseleave');
        );