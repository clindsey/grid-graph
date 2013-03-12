define [
      "models/Creature"
      "Backbone"
    ], (
      CreatureModel) ->

  Creatures = Backbone.Collection.extend
    model: CreatureModel

    initialize: ->

  new Creatures
