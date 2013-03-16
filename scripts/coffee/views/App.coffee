define [
      "views/viewport/Viewport"
      "models/Viewport"
      "views/toolbar/Toolbar"
      "models/heightmap/Heightmap"
      "Alea"
      "Backbone"
    ], (
      ViewportView,
      viewportModel,
      ToolbarView,
      heightmapModel) ->

  AppView = Backbone.View.extend
    el: document

    initialize: ->

      toolbarView = new ToolbarView

      new ViewportView
        toolbarView: toolbarView

      console.log "seed", heightmapModel.get "SEED"
