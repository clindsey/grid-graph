define [
      "models/heightmap/Heightmap"
      "Backbone"
    ], (
      heightmapModel) ->

  Road = Backbone.View.extend
    backgroundPositionX: 0
    backgroundPositionY: -256

    initialize: ->
      #@listenTo @model.get("tileModel"), "neighborChanged", @onNeighborChanged

      roadTileType = @calculateRoadTile()

      @backgroundPositionX = 0 - roadTileType * 16

    onNeighborChanged: ->
      roadTileType = @calculateRoadTile()

      @backgroundPositionX = 0 - roadTileType * 16

      @listenTo @model.get("tileModel").trigger "updateBackgroundPosition"

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

      t = a + b + c + d
