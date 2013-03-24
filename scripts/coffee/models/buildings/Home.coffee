define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Home = BuildingModel.extend
    defaults:
      needsWorker: false
      resources:
        wood: 20
        food: 10
        metal: 0

    initialize: ->
      BuildingModel.prototype.initialize.call @
