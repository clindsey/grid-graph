define [
      "models/entities/Creature"
      "collections/Planets"
      "Backbone"
      "localstorage"
    ], (
      CreatureModel,
      planets) ->

  Creatures = Backbone.Collection.extend
    model: CreatureModel

    initialize: ->
      @listenTo planets, "active", @onPlanetActive

    onPlanetActive: (activePlanet) ->
      @localStorage = new Backbone.LocalStorage "Creatures-#{activePlanet.get "seed"}"

  new Creatures
