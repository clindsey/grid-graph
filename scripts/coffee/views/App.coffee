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
      isPlanetListOpen = false

      toolbarView = new ToolbarView

      galaxy = new GalaxyModel
        seed: 20130401
        size: 5

      viewport = new ViewportView
        toolbarView: toolbarView

      planetListView = new PlanetListView

      @listenTo buildings, "reset", ->
        viewport.render()

        creatures.fetch()

      @listenTo creatures, "reset", ->

      @listenTo planets, "active", (activePlanet) ->
        isPlanetListOpen = false

        buildings.fetch()

      galaxy.generate()

      planets.first().activate()

      @listenTo toolbarView, "toggleSpaceMap", ->
        unless isPlanetListOpen
          planetListView.render()

        isPlanetListOpen = true
