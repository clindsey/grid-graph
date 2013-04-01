define [
      "models/buildings/Building"
      "collections/Planets"
      "Backbone"
      "localstorage"
    ], (
      BuildingModel,
      planets) ->

  Buildings = Backbone.Collection.extend
    model: BuildingModel

    initialize: ->
      @listenTo planets, "active", @onPlanetActive

    onPlanetActive: (activePlanet) ->
      @localStorage =  new Backbone.LocalStorage "Buildings-#{activePlanet.get "seed"}"

  new Buildings
