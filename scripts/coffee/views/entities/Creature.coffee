define [
      "views/entities/Entity"
      "models/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    className: "creature-tile creature-moving entity-tile"

    initialize: ->
      @listenTo @model, "remove", @remove

    render: ->
      EntityView.prototype.render.call this

      @
