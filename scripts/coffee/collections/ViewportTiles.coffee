define [
      "models/ViewportTile"
      "Backbone"
    ], (
      ViewportTileModel) ->

  ViewportTiles = Backbone.Collection.extend
    model: ViewportTileModel

    initialize: ->

  new ViewportTiles
