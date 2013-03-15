define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "models/Heightmap"
      "collections/Creatures"
      "models/Creature"
      "views/entities/Creature"
      "AStar"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel,
      heightmapModel,
      creatures,
      CreatureModel,
      CreatureView,
      AStar) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    events:
      "click": "onClick"

    initialize: ->
      _.bindAll @, "onMapTileClick"

      @render()

      @listenTo viewportModel, "moved", @onViewportMoved

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

      switch @options.toolbarView.activeContext
        when "move"
          ""
        when "road"
          @putRoad tileModel
        when "home"
          @putHome tileModel
        when "farm"
          @putFarm tileModel
        when "refinery"
          @putRefinery tileModel
          @sendFirstWorker tileModel # remove this, exists just for testing
        when "remove"
          if tileModel.get "isOccupied"
            tileModel.removeOccupant()

            creature = tileModel.get "creature"

            creatures.remove creature if creature?

            @informNeighbors tileModel

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

    putHome: (tileModel) ->
      tileModel.set "buildingType", 1

      @informNeighbors tileModel

      x = tileModel.get "x"
      y = tileModel.get "y"

      creature = new CreatureModel x: x, y: y
      creatureView = new CreatureView model: creature

      creatures.add creature

      tileModel.set "creature", creature

      @$el.append creatureView.render().$el

    putFarm: (tileModel) ->
      tileModel.set "buildingType", 3

      @informNeighbors tileModel

    putRefinery: (tileModel) ->
      tileModel.set "buildingType", 2

      @informNeighbors tileModel

    putRoad: (tileModel) ->
      roadType = tileModel.get "roadType"
      occupied = tileModel.get "isOccupied"
      tileType = tileModel.get "type"

      if occupied is false and tileType is 255
        tileModel.set "roadType", 1

        @informNeighbors tileModel

    informNeighbors: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      neighboringTiles = heightmapModel.getNeighboringTiles x, y

      _.each neighboringTiles, (neighboringTile) ->
        neighboringTile.trigger "neighborChanged"

    sendFirstWorker: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      worldTileWidth = heightmapModel.get "worldTileWidth"
      worldTileHeight = heightmapModel.get "worldTileHeight"

      grid = heightmapModel.getPathfindingGrid worldTileWidth, worldTileHeight, x, y

      unemployedCreature = creatures.first()

      worldHalfWidth = Math.ceil worldTileWidth / 2
      worldHalfHeight = Math.ceil worldTileHeight / 2

      deltaX = x - worldHalfWidth
      deltaY = y - worldHalfHeight

      targetX = heightmapModel.clampX unemployedCreature.get("x") - deltaX
      targetY = heightmapModel.clampY unemployedCreature.get("y") - deltaY

      start = [targetX, targetY]
      end = [worldHalfWidth, worldHalfHeight]

      path = AStar grid, start, end

      pathOut = []

      for pathStep, index in path
        if index is 0
          continue
        else
          lastStep = path[index - 1]
          pathOut.push [pathStep[0] - lastStep[0], pathStep[1] - lastStep[1]]

      pathOut.push [0, 0]

      unemployedCreature.set "path", pathOut
