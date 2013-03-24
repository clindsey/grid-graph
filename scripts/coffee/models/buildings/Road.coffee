define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Road = BuildingModel.extend
    defaults:
      needsWorker: false
      resources:
        wood: 5
        food: 0
        metal: 0

    initialize: ->
      BuildingModel.prototype.initialize.call @
