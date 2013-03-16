define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "models/heightmap/Heightmap"
      "collections/Creatures"
      "collections/Buildings"
      "models/entities/Creature"
      "views/entities/Creature"
      "models/Foreman"
      "models/buildings/Home"
      "views/buildings/Home"
      "models/buildings/Farm"
      "views/buildings/Farm"
      "models/buildings/Road"
      "views/buildings/Road"
      "collections/MapTiles"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel,
      heightmapModel,
      creatures,
      buildings,
      CreatureModel,
      CreatureView,
      foremanModel,
      HomeModel,
      HomeView,
      FarmModel,
      FarmView,
      RoadModel,
      RoadView,
      mapTiles) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    events:
      "click": "onClick"

    initialize: ->
      _.bindAll @, "onMapTileClick"

      @render()

      @listenTo viewportModel, "moved", @onViewportMoved
      @listenTo creatures, "add", @onCreatureAdded
      @listenTo buildings, "add", @onBuildingAdded
      @listenTo buildings, "remove", @onBuildingRemoved

    render: ->
      @$el.css
        width: viewportModel.get("width") * 16
        height: viewportModel.get("height") * 16

      @grid = []

      viewportTiles.each (mapTileModel) =>
        viewportTileView = new ViewportTileView
        viewportTileView.setModel mapTileModel

        @$el.append viewportTileView.render().$el

        viewportTileView.$el.click =>
          @onMapTileClick viewportTileView

        @grid.push viewportTileView

      interval = (time, cb) -> setInterval cb, time

      interval 1000 / 1, =>
        creatures.invoke "trigger", "tick"

      @

    onClick: (jqEvent) ->
      if @options.toolbarView.activeContext is "move"
        @moveViewport jqEvent

    onMapTileClick: (viewportTileView) ->
      tileModel = viewportTileView.model

      context = @options.toolbarView.activeContext

      if tileModel.get("isOccupied") is true and context isnt "remove"
        return

      if tileModel.get("type") isnt 255
        return

      switch @options.toolbarView.activeContext
        when "move"
          ""
        when "road"
          foremanModel.putRoad tileModel

        when "home"
          foremanModel.putHome tileModel

        when "farm"
          foremanModel.putFarm tileModel

        when "remove"
          if tileModel.get "isOccupied"
            foremanModel.removeBuilding tileModel

    moveViewport: (jqEvent) ->
      viewportWidth = viewportModel.get "width"
      viewportHeight = viewportModel.get "height"

      tileX = ~~(jqEvent.target.offsetLeft / 16)
      tileY = ~~(jqEvent.target.offsetTop / 16)

      vx = tileX - ~~(viewportWidth / 2)
      vy = tileY - ~~(viewportHeight / 2)

      viewportX = viewportModel.get "x"
      viewportY = viewportModel.get "y"

      viewportModel.set
        x: viewportX + vx
        y: viewportY + vy

    onViewportMoved: ->
      _.each @grid, (viewportTileView, index) ->
        viewportTileView.setModel viewportTiles.at index

    onCreatureAdded: (creatureModel) ->
      creatureView = new CreatureView model: creatureModel

      @$el.append creatureView.render().$el

    onBuildingRemoved: (buildingModel) ->
      tileModels = mapTiles.where
        x: buildingModel.get "x"
        y: buildingModel.get "y"

      tileModel = _.first tileModels

      tileModel.set "buildingView", undefined

      creatureModel = buildingModel.get "creature"

      if creatureModel?
        creatures.remove creatureModel

        workSite = creatureModel.get "workSite"

        if workSite?
          workSite.set "worker", undefined

    onBuildingAdded: (buildingModel) ->
      if buildingModel instanceof HomeModel
        buildingView = new HomeView model: buildingModel

      else if buildingModel instanceof FarmModel
        buildingView = new FarmView model: buildingModel

      else if buildingModel instanceof RoadModel
        buildingView = new RoadView model: buildingModel

      else
        return

      tileModels = mapTiles.where
        x: buildingModel.get "x"
        y: buildingModel.get "y"

      tileModel = _.first tileModels

      tileModel.set "buildingView", buildingView
