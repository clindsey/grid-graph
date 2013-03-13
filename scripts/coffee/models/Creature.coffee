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

      @set "state", machine.generateTree @behaviorTree, @, @states

      @listenTo @, "tick", =>
        @set "state", @get("state").tick()

    behaviorTree:
      identifier: "idle"
      strategy: "prioritised"
      children: [
        { identifier: "followPath" }
      ]

    states:
      idle: ->

      followPath: ->
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
            @set
              "x": mx
              "y": my

            break

      canFollowPath: ->
        true
