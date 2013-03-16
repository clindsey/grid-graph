define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Buildings = Backbone.Collection.extend
    model: BuildingModel

  new Buildings
