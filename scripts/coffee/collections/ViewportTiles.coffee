define [
      "models/MapTile"
      "Backbone"
    ], (
      MapTileModel) ->

  ViewportTiles = Backbone.Collection.extend
    model: MapTileModel

  new ViewportTiles
