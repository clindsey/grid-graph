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
      "models/buildings/ExportCenter"
      "views/buildings/ExportCenter"
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
      "models/Overview"
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
      ExportCenterModel,
      ExportCenterView,
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
      mapTiles,
      overview) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    events:
      "click": "onClick"

    initialize: ->
      _.bindAll @, "onMapTileClick"

      @listenTo viewportModel, "moved", @onViewportMoved
      @listenTo creatures, "add", @onCreatureAdded
      @listenTo buildings, "add", @onBuildingAdded
      @listenTo buildings, "remove", @onBuildingRemoved
      @listenTo buildings, "reset", @onBuildingsReset
      @listenTo creatures, "reset", @onCreaturesReset

      @render()

    render: ->
      @$el.empty()

      @$el.css
        width: viewportModel.get("width") * (16 * 2)
        height: viewportModel.get("height") * (16 * 2)

      @grid = []

      viewportTiles.each (mapTileModel) =>
        viewportTileView = new ViewportTileView
        viewportTileView.setModel mapTileModel

        @$el.append viewportTileView.render().$el

        viewportTileView.$el.click =>
          @onMapTileClick viewportTileView

        @grid.push viewportTileView

      interval = (time, cb) ->
        clearTimeout window.timeout

        window.timeout = setInterval cb, time

      interval 1000 / 1, @onIntervalTick

      @

    onIntervalTick: ->
      creatures.invoke "trigger", "tick"
      ###
      try # extremely unhappy about this, absolutely no good reason to ever use try...catch, just shows i have no idea whats happening in my code
      catch err
        console.log "machine.js state tick err:", err
      ###

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

        when "export center"
          foremanModel.putExportCenter tileModel

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

      tileX = ~~(jqEvent.target.offsetLeft / (16 * 2))
      tileY = ~~(jqEvent.target.offsetTop / (16 * 2))

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

      creatureModel = _.first creatures.where # creature lives here
        id: buildingModel.get "creatureFk"

      if creatureModel?
        creatures.sync "delete", creatureModel

        creatures.remove creatureModel

        workSite = _.first buildings.where
          id: creatureModel.get "workSiteFk"

        if workSite?
          workSite.set "workerFk", undefined

          buildings.sync "update", workSite

          foremanModel.findWorker workSite

      creatureModel = _.first creatures.where # creature works here 
        id: buildingModel.get "workerFk"

      if creatureModel?
        creatureModel.set "workSiteFk", undefined

        creatures.sync "update", creatureModel

        foremanModel.findJob creatureModel

    onCreaturesReset: ->
      creatures.each (creature) =>
        @onCreatureAdded creature

        creature.state.warp creature.get "stateIdentifier"

    onBuildingsReset: ->
      models = []

      _.each buildings.toArray(), (buildingModel) =>
        buildings.remove buildingModel,
          silent: true

        switch buildingModel.get "type"
          when "Home"
            model = new HomeModel buildingModel.attributes
          when "ExportCenter"
            model = new ExportCenterModel buildingModel.attributes
          when "Farm"
            model = new FarmModel buildingModel.attributes
          when "Road"
            model = new RoadModel buildingModel.attributes
          when "Mine"
            model = new MineModel buildingModel.attributes
          when "LumberMill"
            model = new LumberMillModel buildingModel.attributes
          when "WaterWell"
            model = new WaterWellModel buildingModel.attributes
          when "Factory"
            model = new FactoryModel buildingModel.attributes
          else
            return

        models.push model

      buildings.reset [],
        silent: true

      buildings.reset models,
        silent: true

      buildings.each (buildingModel) =>
        @onBuildingAdded buildingModel

      buildings.each (buildingModel) =>
        foremanModel.informNeighbors buildingModel

    onBuildingAdded: (buildingModel) ->
      switch buildingModel.get "type"
        when "Home"
          buildingView = new HomeView model: buildingModel
        when "ExportCenter"
          buildingView = new ExportCenterView model: buildingModel
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

      buildingModel.trigger "calculateBackgroundPosition"

      tileModel = _.first mapTiles.where
        x: buildingModel.get "x"
        y: buildingModel.get "y"

      tileModel.set "buildingView", buildingView
