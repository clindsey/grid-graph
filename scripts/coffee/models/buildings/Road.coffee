define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Road = BuildingModel.extend
    initialize: ->
      BuildingModel.prototype.initialize.call @
