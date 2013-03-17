define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Farm = BuildingModel.extend
    defaults:
      needsWorker: true
      stage: 0
      cost: 20
      value: 10

    initialize: ->
      BuildingModel.prototype.initialize.call @

      @listenTo @, "worked", @onWorked

    onWorked: ->
      newStage = (@get("stage") + 1) % 4

      @set "stage", newStage

      if newStage is 0
        @trigger "madeMoney", @get "value"

      @trigger "calculateBackgroundPosition"

      @get("tileModel").trigger "updateBackgroundPosition"
