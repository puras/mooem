Ember.RadioButton = Ember.View.extend
    tagName: 'input'
    type: 'radio'
    selection: null
    attributeBindings: ['name', 'type', 'value', 'checked:checked:']

    checked: (->
        @get('selection') != null and @get('value').toString() == @get('selection').toString()
    ).property('selection')

    click: (event)->
        @set 'selection', @.$().val()