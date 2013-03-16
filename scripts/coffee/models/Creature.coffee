define [
      "models/Entity"
      "models/Heightmap"
      "Machine"
      "Backbone"
    ], (
      EntityModel,
      heightmapModel) ->

  Creature = EntityModel.extend
    defaults:
      path: []

    initialize: ->
      machine = new Machine

      @set "direction", "south"

      @set "state", machine.generateTree @behaviorTree, @, @states

      @listenTo @, "tick", =>
        @set "state", @get("state").tick()

    behaviorTree:
      identifier: "sleep"
      strategy: "prioritised"
      children: [
        { identifier: "walk" }
      ]

    states:
      sleep: ->

      canSleep: ->
        !@get("path").length

      walk: ->
        path = @get "path"

        nearRoad = path.shift()

        @set "path", path

        return unless !!nearRoad.length

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
