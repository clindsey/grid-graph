define [
      "views/entities/Entity"
      "models/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    className: "creature-tile creature-moving entity-tile"

    initialize: ->
      EntityView.prototype.initialize.call @

      @listenTo @model, "change:state", @onStateChange
      @listenTo @model, "change:direction", @onDirectionChange

      @currentState = @model.get("state").identifer
      @currentDirection = @model.get "direction"

      @setClassName

    onStateChange: ->
      @removeClassName()

      @currentState = @model.get("state").identifier

      console.log @currentState

      @setClassName()

    onDirectionChange: ->
      @removeClassName()

      @currentDirection = @model.get "direction"

      @setClassName()

    removeClassName: ->
      @$el.removeClass "#{@currentState}-#{@currentDirection}"

    setClassName: ->
      @$el.addClass "#{@currentState}-#{@currentDirection}"
