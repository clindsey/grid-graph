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

      @listenTo @model, "change:stateIdentifier", @onStateChange
      @listenTo @model, "change:direction", @onDirectionChange
      @listenTo @model, "step", @onStep

      @currentState = @model.get "stateIdentifier"
      @currentDirection = @model.get "direction"

      @setClassName

    onStateChange: ->
      @removeClassName()

      @currentState = @model.get "stateIdentifier"

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
        "margin-left": 0 - vector[0] * (16 * 2)
        "margin-top": 0 - vector[1] * (16 * 2)

      @$el.animate {
          "margin-left": 0
          "margin-top": 0
        }, {
          duration: 950
          easing: "linear"
        }
