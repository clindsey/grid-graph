define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Road = BuildingModel.extend
    defaults:
      cost: 5
      needsWorker: false

    initialize: ->
      BuildingModel.prototype.initialize.call @
