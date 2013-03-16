define [
      "models/Entity"
      "models/Heightmap"
      "AStar"
      "Machine"
      "Backbone"
    ], (
      EntityModel,
      heightmapModel,
      AStar) ->

  Creature = EntityModel.extend
    defaults:
      path: []
      workSite: undefined
      home: undefined

    initialize: ->
      machine = new Machine

      @set "direction", "south"

      @set "state", machine.generateTree @behaviorTree, @, @states

      @listenTo @, "tick", =>
        @set "state", @get("state").tick()

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
        workSiteModel = @get "workSite"

        unless workSiteModel?
          return

        path = @findPath workSiteModel

        if path.length is 0
          return

        @set "path", path

      canSleep: ->
        path = @get "path"

        if path.length isnt 0
          return false

        homeModel = @get "home"

        if homeModel is undefined
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
          "x": @get("x") + nearRoad[0]
          "y": @get("y") + nearRoad[1]

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
        homeModel = @get "home"

        path = @findPath homeModel

        if path.length is 0
          return

        @set "path", path

      canWater: ->
        path = @get "path"

        if path.length isnt 0
          return false

        workSiteModel = @get "workSite"

        if workSiteModel is undefined
          return false

        workX = workSiteModel.get "x"
        workY = workSiteModel.get "y"

        x = @get "x"
        y = @get "y"

        x is workX and y is workY
