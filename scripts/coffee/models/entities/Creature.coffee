define [
      "models/entities/Entity"
      "models/heightmap/Heightmap"
      "collections/Buildings"
      "AStar"
      "Machine"
      "Backbone"
    ], (
      EntityModel,
      heightmapModel,
      buildings,
      AStar) ->

  Creature = EntityModel.extend
    defaults:
      path: []
      workSiteFk: undefined
      homeFk: undefined

    initialize: ->
      machine = new Machine

      @set "direction", "south"

      @state = machine.generateTree @behaviorTree, @, @states
      @set "stateIdentifier", @state.identifier

      @listenTo @, "tick", =>
        @state = @state.tick()
        @set "stateIdentifier", @state.identifier

        @collection.sync "update", @

    getWorkSite: ->
      _.first buildings.where
        id: @get "workSiteFk"

    getHomeSite: ->
      _.first buildings.where
        id: @get "homeFk"

    findPath: (tileModel) ->
      x = @get "x"
      y = @get "y"

      worldTileWidth = heightmapModel.get "worldTileWidth"
      worldTileHeight = heightmapModel.get "worldTileHeight"

      grid = heightmapModel.getPathfindingGrid worldTileWidth, worldTileHeight, x, y

      worldHalfWidth = Math.ceil worldTileWidth / 2
      worldHalfHeight = Math.ceil worldTileHeight / 2

      deltaX = x - worldHalfWidth
      deltaY = y - worldHalfHeight

      targetX = heightmapModel.clampX tileModel.get("x") - deltaX
      targetY = heightmapModel.clampY tileModel.get("y") - deltaY

      start = [worldHalfWidth, worldHalfHeight]
      end = [targetX, targetY]

      path = AStar grid, start, end

      if path.length is 0
        return []

      pathOut = []

      for pathStep, index in path
        if index is 0
          continue
        else
          lastStep = path[index - 1]
          pathOut.push [pathStep[0] - lastStep[0], pathStep[1] - lastStep[1]]

      pathOut.push [0, 0]

      pathOut

    behaviorTree:
      identifier: "sleep"
      strategy: "sequential"
      children: [
        { identifier: "sleep" }
        { identifier: "walk" }
        {
          identifier: "water"
          strategy: "sequential"
          children: [
            { identifier: "water" }
            { identifier: "walk" }
          ]
        }
      ]

    states:
      sleep: ->
        workSiteModel = @getWorkSite()

        unless workSiteModel?
          return

        path = @findPath workSiteModel

        if path.length is 0
          return

        @set "path", path

      canSleep: ->
        path = @get "path"

        workSiteModel = @getWorkSite()

        if @get("home")? is false or workSiteModel? is false
          if path.length is 0
            return true

        if path.length isnt 0
          return false

        homeModel = @getHomeSite()

        unless homeModel?
          return false

        homeX = homeModel.get "x"
        homeY = homeModel.get "y"

        x = @get "x"
        y = @get "y"

        x is homeX and y is homeY

      walk: ->
        path = @get "path"

        nearRoad = path.shift()

        @set "path", path

        return unless nearRoad? and !!nearRoad.length

        @trigger "step", nearRoad

        @set
          "x": heightmapModel.clampX @get("x") + nearRoad[0]
          "y": heightmapModel.clampY @get("y") + nearRoad[1]

        direction = "south"

        if nearRoad[0] is 1
          direction = "east"
        if nearRoad[0] is -1
          direction = "west"
        if nearRoad[1] is 1
          direction = "south"
        if nearRoad[1] is -1
          direction = "north"

        @set "direction", direction

      canWalk: ->
        !!@get("path").length

      water: ->
        homeModel = @getHomeSite()

        path = @findPath homeModel

        if path.length is 0
          return

        workSite = @getWorkSite()

        workSite.trigger "worked"

        buildings.sync "update", workSite

        @set "path", path

      canWater: ->
        path = @get "path"

        if path.length isnt 0
          return false

        workSiteModel = @getWorkSite()

        unless workSiteModel?
          homeModel = @getHomeSite()

          path = @findPath homeModel

          if path.length <= 1
            return false

          @set "path", path

          @set "state", @get("state").warp("water")
          return false

        workX = workSiteModel.get "x"
        workY = workSiteModel.get "y"

        x = @get "x"
        y = @get "y"

        x is workX and y is workY
