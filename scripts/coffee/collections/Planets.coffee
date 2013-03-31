define [
      "models/Planet"
      "Backbone"
    ], (
      PlanetModel) ->

  Planets = Backbone.Collection.extend
    model: PlanetModel

  new Planets
