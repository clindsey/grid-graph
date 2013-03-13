define [
      "views/entities/Entity"
      "models/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    className: "creature-tile creature-moving entity-tile"
