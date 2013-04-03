define [
      "models/heightmap/Heightmap"
      "Backbone"
    ], (
      heightmapModel) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    render: ->
      @$el.removeClass "water-tile"

      @calculateBackgroundPosition()

      @setBackgroundPosition()

      @

    setModel: (model) ->
      @model = model

      @setListeners()

      @render()

    calculateBackgroundPosition: ->
      buildingView = @model.get "buildingView"

      if buildingView?
        @backgroundPositionX = buildingView.backgroundPositionX
        @backgroundPositionY = buildingView.backgroundPositionY
      else
        type = @model.get "type"

        if type is 0
          @$el.addClass "water-tile"

        @backgroundPositionX = 0 - ((type % 16) * 32)
        @backgroundPositionY = 0 - (~~(type / 16) * 32)

    setListeners: ->
      @listenTo @model, "change:isOccupied", @render

      @listenTo @model, "updateBackgroundPosition", @render

      @listenTo @model, "change:buildingView", @render

    setBackgroundPosition: ->
      @$el.css
        backgroundPosition: "#{@backgroundPositionX}px #{@backgroundPositionY}px"

      @
