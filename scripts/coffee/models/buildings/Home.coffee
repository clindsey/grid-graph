define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Home = BuildingModel.extend
    defaults:
      cost: 25
      needsWorker: false

    initialize: ->
      BuildingModel.prototype.initialize.call @
