define [
      "views/entities/Entity"
      "models/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    className: "creature-tile creature-moving entity-tile"

    initialize: ->
      EntityView.prototype.initialize.call this

      @listenTo @model, "remove", @remove
