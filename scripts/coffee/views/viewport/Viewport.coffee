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
      "models/buildings/Mine"
      "views/buildings/Mine"
      "models/buildings/LumberMill"
      "views/buildings/LumberMill"
      "models/buildings/WaterWell"
      "views/buildings/WaterWell"
      "models/buildings/Factory"
      "views/buildings/Factory"
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
      MineModel,
      MineView,
      LumberMillModel,
      LumberMillView,
      WaterWellModel,
      WaterWellView,
      FactoryModel,
      FactoryView,
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
      @listenTo buildings, "reset", @onBuildingsReset

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
        try # extremely unhappy about this, absolutely no good reason to ever use try...catch, just shows i have no idea whats happening in my code
          creatures.invoke "trigger", "tick"
        catch err
          console.log "machine.js state tick err:", err

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

        when "mine"
          foremanModel.putMine tileModel

        when "lumber mill"
          foremanModel.putLumberMill tileModel

        when "water well"
          foremanModel.putWaterWell tileModel

        when "factory"
          foremanModel.putFactory tileModel

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

      creatureModel = buildingModel.get "worker"

      if creatureModel?
        creatureModel.set "workSite", undefined

    onBuildingsReset: ->
      buildings.each (building) =>
        @onBuildingAdded building

    onBuildingAdded: (buildingModel) ->
      switch buildingModel.get "type"
        when "Home"
          buildingView = new HomeView model: buildingModel
        when "Farm"
          buildingView = new FarmView model: buildingModel
        when "Road"
          buildingView = new RoadView model: buildingModel
        when "Mine"
          buildingView = new MineView model: buildingModel
        when "LumberMill"
          buildingView = new LumberMillView model: buildingModel
        when "WaterWell"
          buildingView = new WaterWellView model: buildingModel
        when "Factory"
          buildingView = new FactoryView model: buildingModel
        else
          return

      tileModels = mapTiles.where
        x: buildingModel.get "x"
        y: buildingModel.get "y"

      tileModel = _.first tileModels

      tileModel.set "buildingView", buildingView
