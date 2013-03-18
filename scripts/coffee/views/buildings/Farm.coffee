define [
      "views/buildings/Workable"
      "Backbone"
    ], (
      WorkableView) ->

  Farm = WorkableView.extend
    backgroundPositionX: -32
    backgroundPositionY: -272

    calculateBackgroundPosition: ->
      @backgroundPositionX = 0 - 32 - (@model.get("stage") * 16)
