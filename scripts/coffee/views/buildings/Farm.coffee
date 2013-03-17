define [
      "Backbone"
    ], (
      ) ->

  Farm = Backbone.View.extend
    backgroundPositionX: -32
    backgroundPositionY: -272

    initialize: ->
      @listenTo @model, "calculateBackgroundPosition", @calculateBackgroundPosition

      @calculateBackgroundPosition

    calculateBackgroundPosition: ->
      @backgroundPositionX = 0 - 32 - (@model.get("stage") * 16)

    render: ->
