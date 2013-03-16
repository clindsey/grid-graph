define [
      "views/entities/Entity"
      "models/heightmap/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    className: "creature-tile entity-tile"

    initialize: ->
      EntityView.prototype.initialize.call @

      @listenTo @model, "change:state", @onStateChange
      @listenTo @model, "change:direction", @onDirectionChange
      @listenTo @model, "step", @onStep

      @currentState = @model.get("state").identifer
      @currentDirection = @model.get "direction"

      @setClassName

    onStateChange: ->
      @removeClassName()

      @currentState = @model.get("state").identifier

      @setClassName()

    onDirectionChange: ->
      @removeClassName()

      @currentDirection = @model.get "direction"

      @setClassName()

    removeClassName: ->
      @$el.removeClass "#{@currentState}-#{@currentDirection}"

    setClassName: ->
      @$el.addClass "#{@currentState}-#{@currentDirection}"

    onStep: (vector) ->
      @$el.css
        "margin-left": 0 - vector[0] * 16
        "margin-top": 0 - vector[1] * 16

      @$el.animate {
          "margin-left": 0
          "margin-top": 0
        }, {
          duration: 950
          easing: "linear"
        }
