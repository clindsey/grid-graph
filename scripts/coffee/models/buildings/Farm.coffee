define [
      "models/buildings/Workable"
      "collections/ViewportTiles"
      "Backbone"
    ], (
      WorkableModel,
      viewportTiles) ->

  Farm = WorkableModel.extend
    defaults:
      type: "Farm"
      needsWorker: true
      stage: 0
      resources:
        wood: 20
        food: 0
        metal: 0
      production:
        wood: 0
        food: 45
        metal: 0

    onWorked: ->
      newStage = (@get("stage") + 1) % 4

      @set "stage", newStage

      if newStage is 0
        @trigger "madeResources", @get "production"

      @trigger "calculateBackgroundPosition"

      mapTile = _.first viewportTiles.where
        x: @get "x"
        y: @get "y"

      mapTile.trigger("updateBackgroundPosition") if mapTile?
