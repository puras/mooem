StatusCodes = Ember.Object.extend
    200: ->
        console.log 'Status code 200: Success.'
    202: ->
        console.log "Status code 202: Success for creation."
    400: ->
        console.log "Error code 400: Bad Request."
    401: ->
        console.log "Error code 401: Unauthorized."
    402: ->
        console.log "Error code 402: Payment Required."
    403: ->
        console.log "Error code 403: Forbidden."
        #App.router.logOff()
    404: ->
        console.log "Error code 404: URI not found."
    500: ->
        console.log "Error code 500: Internal Error on server side."
    501: ->
        console.log "Error code 501: Not implemented yet."
    502: ->
        console.log "Error code 502: Services temporarily overloaded."
    503: ->
        console.log "Error code 503: Gateway timeout."

App.status_codes = StatusCodes.create({})