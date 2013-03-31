define [
      "models/heightmap/Heightmap"
      "collections/ViewportTiles"
      "Backbone"
    ], (
      heightmapModel,
      viewportTiles) ->

  Road = Backbone.View.extend
    backgroundPositionX: 0
    backgroundPositionY: -256

    initialize: ->
      @listenTo @model, "neighborChanged", @onNeighborChanged

      roadTileType = @calculateRoadTile()

      @backgroundPositionX = 0 - roadTileType * 16

    onNeighborChanged: ->
      roadTileType = @calculateRoadTile()

      @backgroundPositionX = 0 - roadTileType * 16

      mapTile = _.first viewportTiles.where
        x: @model.get "x"
        y: @model.get "y"

      mapTile.trigger("updateBackgroundPosition") if mapTile?

    calculateRoadTile: ->
      x = @model.get "x"
      y = @model.get "y"

      neighboringTiles = heightmapModel.getNeighboringTiles x, y

      n = neighboringTiles.n.get "isOccupied"
      e = neighboringTiles.e.get "isOccupied"
      s = neighboringTiles.s.get "isOccupied"
      w = neighboringTiles.w.get "isOccupied"

      a = n << n * 4 - 4
      b = e << e * 4 - 3
      c = s << s * 4 - 2
      d = w << w * 4 - 1

      a + b + c + d
