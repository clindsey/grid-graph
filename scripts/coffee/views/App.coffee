define [
      "views/viewport/Viewport"
      "models/Viewport"
      "views/toolbar/Toolbar"
      "models/heightmap/Heightmap"
      "models/Galaxy"
      "views/planetList/PlanetList"
      "collections/Planets"
      "Alea"
      "Backbone"
    ], (
      ViewportView,
      viewportModel,
      ToolbarView,
      heightmapModel,
      GalaxyModel,
      PlanetListView,
      planets) ->

  AppView = Backbone.View.extend
    el: document

    initialize: ->
      toolbarView = new ToolbarView

      galaxy = new GalaxyModel
        seed: 20130910
        size: 20

      new PlanetListView

      galaxy.generate()

      new ViewportView
        toolbarView: toolbarView
