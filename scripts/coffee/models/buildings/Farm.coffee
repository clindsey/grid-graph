define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  Farm = WorkableModel.extend
    defaults:
      needsWorker: true
      stage: 0
      cost: 10
      value: 30

    onWorked: ->
      newStage = (@get("stage") + 1) % 4

      @set "stage", newStage

      if newStage is 0
        @trigger "madeMoney", @get "value"

      @trigger "calculateBackgroundPosition"

      @get("tileModel").trigger "updateBackgroundPosition"
