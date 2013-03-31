define [
      "models/entities/Creature"
      "Backbone"
      "localstorage"
    ], (
      CreatureModel) ->

  Creatures = Backbone.Collection.extend
    model: CreatureModel

    localStorage: new Backbone.LocalStorage("Creatures")

  new Creatures
