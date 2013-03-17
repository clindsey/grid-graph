define [
      "views/viewport/Viewport"
      "models/Viewport"
      "views/toolbar/Toolbar"
      "models/heightmap/Heightmap"
      "Alea"
      "Backbone"
      "Bootstrap"
    ], (
      ViewportView,
      viewportModel,
      ToolbarView,
      heightmapModel) ->

  AppView = Backbone.View.extend
    el: document

    initialize: ->
      $("[data-toggle=tooltip]").tooltip
        container: "body"

      toolbarView = new ToolbarView

      new ViewportView
        toolbarView: toolbarView

      console.log "seed", heightmapModel.get "SEED"
