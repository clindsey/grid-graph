define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Farm = BuildingModel.extend
    defaults:
      needsWorker: true
      stage: 0

    initialize: ->
      BuildingModel.prototype.initialize.call @

      @listenTo @, "worked", @onWorked

    onWorked: ->
      @set "stage", (@get("stage") + 1) % 4

      @trigger "calculateBackgroundPosition"

      @get("tileModel").trigger "updateBackgroundPosition"
