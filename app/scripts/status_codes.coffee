StatusCodes = Ember.Object.extend
    200: ->
        console.log 'Status code 200: Success.'

App.status_codes = StatusCodes.create({})