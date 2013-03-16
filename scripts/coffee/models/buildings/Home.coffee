define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Home = BuildingModel.extend
    initialize: ->
      BuildingModel.prototype.initialize.call @
