define [
      "models/Heightmap"
      "collections/ViewportTiles"
      "Backbone"
    ], (
      heightmap,
      viewportTiles) ->

  Viewport = Backbone.Model.extend
    defaults:
      x: 0
      y: 0
      width: 20
      height: 20

    initialize: ->
      @listenTo @, "change:x", @updateTiles
      @listenTo @, "change:y", @updateTiles

      @updateTiles()

    clamp: (index, size) ->
      (index + size) % size

    updateTiles: ->
      viewportX = @get "x"
      viewportY = @get "y"

      @set
        x: @clamp @get("x"), heightmap.get("worldTileWidth")
        y: @clamp @get("y"), heightmap.get("worldTileHeight")

      viewportTiles.remove viewportTiles.models

      for tileRow in heightmap.getArea @get("width"), @get("height"), @get("x"), @get("y")
        for tile in tileRow
          viewportTiles.add tile

      @trigger "moved"

  new Viewport
