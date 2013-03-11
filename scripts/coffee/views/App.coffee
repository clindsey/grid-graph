define [
      "views/viewport/Viewport"
      "models/Viewport"
      "views/toolbar/Toolbar"
      "Backbone"
    ], (
      ViewportView,
      viewportModel,
      ToolbarView) ->

  AppView = Backbone.View.extend
    el: document

    initialize: ->
      toolbarView = new ToolbarView

      new ViewportView
        toolbarView: toolbarView
