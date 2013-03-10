define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "models/Heightmap"
      "Alea"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel,
      heightmapModel) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    initialize: ->
      @rnd = new Alea(heightmapModel.get "SEED")

      @render()

      @listenTo viewportModel, "moved", @onViewportMoved

    render: ->
      @$el.css
        width: viewportModel.get("width") * 16
        height: viewportModel.get("height") * 16

      @grid = []

      viewportTiles.each (viewportTileModel) =>
        viewportTileView = new ViewportTileView
        viewportTileView.setModel viewportTileModel

        @$el.append viewportTileView.render().$el

        @grid.push viewportTileView

      @

    onViewportMoved: ->
      $(".creature-moving").removeClass("creature-moving")

      clearTimeout @timeout

      _.each @grid, (viewportTileView, index) ->
        viewportTileView.setModel viewportTiles.at index
