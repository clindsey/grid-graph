define [
      "models/heightmap/Heightmap"
      "Alea"
      "Backbone"
    ], (
      heightmapModel) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    render: ->
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

        @backgroundPositionX = 0 - ((type % 16) * 32)
        @backgroundPositionY = 0 - (~~(type / 16) * 32)

        if type is 255
          seed = @model.get "seed"

          if seed > 0.9125
            @backgroundPositionX = 0
            @backgroundPositionY = -512

          if seed > 0.9875
            @backgroundPositionX = -192
          else if seed > 0.975
            @backgroundPositionX = -160
          else if seed > 0.9625
            @backgroundPositionX = -128
          else if seed > 0.95
            @backgroundPositionX = -96
          else if seed > 0.9375
            @backgroundPositionX = -64
          else if seed > 0.925
            @backgroundPositionX = -32
          else if seed > 0.9125
            @backgroundPositionX = -0

    setListeners: ->
      @listenTo @model, "change:isOccupied", @render

      @listenTo @model, "updateBackgroundPosition", @render

      @listenTo @model, "change:buildingView", @render

    setBackgroundPosition: ->
      @$el.css
        backgroundPosition: "#{@backgroundPositionX}px #{@backgroundPositionY}px"

      @
