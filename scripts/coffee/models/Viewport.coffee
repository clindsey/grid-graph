define [
      "models/heightmap/Heightmap"
      "collections/ViewportTiles"
      "Backbone"
    ], (
      heightmapModel,
      viewportTiles) ->

  Viewport = Backbone.Model.extend
    defaults:
      x: 0
      y: 0
      width: 21
      height: 21

    initialize: ->
      @listenTo @, "change:x", @updateTiles
      @listenTo @, "change:y", @updateTiles

      @listenTo heightmapModel, "change:data", @updateTiles

    updateTiles: ->
      viewportX = heightmapModel.clampX @get "x"
      viewportY = heightmapModel.clampY @get "y"

      @set
        x: viewportX
        y: viewportY

      viewportTiles.remove viewportTiles.models

      for tileRow in heightmapModel.getArea @get("width"), @get("height"), viewportX, viewportY
        for tile in tileRow
          viewportTiles.add tile

      @trigger "moved"

  new Viewport
