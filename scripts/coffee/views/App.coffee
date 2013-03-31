define [
      "views/viewport/Viewport"
      "models/Viewport"
      "views/toolbar/Toolbar"
      "models/heightmap/Heightmap"
      "models/Galaxy"
      "views/planetList/PlanetList"
      "collections/Planets"
      "collections/Buildings"
      "collections/Creatures"
      "Alea"
      "Backbone"
    ], (
      ViewportView,
      viewportModel,
      ToolbarView,
      heightmapModel,
      GalaxyModel,
      PlanetListView,
      planets,
      buildings,
      creatures) ->

  AppView = Backbone.View.extend
    el: document

    initialize: ->
      toolbarView = new ToolbarView

      galaxy = new GalaxyModel
        seed: 20130330
        size: 1

      new PlanetListView

      galaxy.generate()

      new ViewportView
        toolbarView: toolbarView

      @listenTo buildings, "reset", ->
        creatures.fetch()

      buildings.fetch()
