define [
      "Backbone"
    ], (
      ) ->

  Workable = Backbone.View.extend
    backgroundPositionX: 0
    backgroundPositionY: 0

    initialize: ->
      @listenTo @model, "calculateBackgroundPosition", @calculateBackgroundPosition

      @calculateBackgroundPosition

    calculateBackgroundPosition: ->

    render: ->
