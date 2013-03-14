define [
      "models/Entity"
      "models/Heightmap"
      "Machine"
      "Backbone"
    ], (
      EntityModel,
      heightmapModel) ->

  Creature = EntityModel.extend
    initialize: ->
      machine = new Machine

      @set "direction", "south"

      @set "state", machine.generateTree @behaviorTree, @, @states

      @listenTo @, "tick", =>
        @set "state", @get("state").tick()

    nearbyRoads: ->
      dirCombos = [
        [1, 0]
        [-1, 0]
        [0, 1]
        [0, -1]
      ]

      dirCombos = _.shuffle dirCombos

      while dirCombos.length
        dir = dirCombos.pop()

        vx = dir[0]
        vy = dir[1]

        mx = heightmapModel.clampX @get("x") + vx
        my = heightmapModel.clampY @get("y") + vy

        heightmapData = heightmapModel.get "data"

        if heightmapData[my][mx].get("roadType") is 1
          return [vx, vy]

      []

    behaviorTree:
      identifier: "idle"
      strategy: "prioritised"
      children: [
        { identifier: "walk" }
        {
          identifier: "sleep"
          strategy: "sequential"
          children: [
            { identifier: "walk" }
            { identifier: "idle" }
          ]
        }
      ]

    states:
      idle: ->
      canIdle: ->

      sleep: ->
      canSleep: ->
        !@nearbyRoads().length

      walk: ->
        nearRoad = @nearbyRoads()

        return unless !!nearRoad.length

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
        !!@nearbyRoads().length
