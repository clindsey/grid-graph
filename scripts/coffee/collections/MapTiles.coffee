define [
      "models/MapTile"
      "Backbone"
    ], (
      MapTileModel) ->

  MapTiles = Backbone.Collection.extend
    model: MapTileModel

  new MapTiles
