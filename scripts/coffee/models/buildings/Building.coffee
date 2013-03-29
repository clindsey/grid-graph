define [
      "Backbone"
    ], (
      ) ->

  Building = Backbone.Model.extend
    defaults:
      type: "Building"
      needsWorker: false
      resources:
        wood: 0
        food: 0
        metal: 0

    initialize: ->
