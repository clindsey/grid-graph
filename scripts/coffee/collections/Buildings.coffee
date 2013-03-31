define [
      "models/buildings/Building"
      "Backbone"
      "localstorage"
    ], (
      BuildingModel) ->

  Buildings = Backbone.Collection.extend
    model: BuildingModel

    localStorage: new Backbone.LocalStorage("Buildings")

  new Buildings
