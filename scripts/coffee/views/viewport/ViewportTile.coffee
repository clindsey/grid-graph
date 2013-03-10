define [
      "models/Heightmap"
      "Backbone"
    ], (
      heightmap) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    events:
      "click": "onClick"

    render: ->
      @calculateBackgroundPosition()

      @setBackgroundPosition()

      @

    setModel: (model) ->
      @model = model

      @setListeners()

      @render()

    onClick: ->
      roadType = @model.get "roadType"
      tileType = @model.get "type"

      if roadType is 1 or tileType is 255
        if roadType is 1
          @model.set "roadType", 0
        else
          @model.set "roadType", 1

        x = @model.get "x"
        y = @model.get "y"

        heightmap.get("data")[@clampY y - 1][x].trigger "neighborRoadChanged"
        heightmap.get("data")[y][@clampX x + 1].trigger "neighborRoadChanged"
        heightmap.get("data")[@clampY y + 1][x].trigger "neighborRoadChanged"
        heightmap.get("data")[y][@clampX x - 1].trigger "neighborRoadChanged"

    clampX: (x) ->
      width = heightmap.get("worldTileWidth")

      (x + width) % width

    clampY: (y) ->
      height = heightmap.get("worldTileHeight")

      (y + height) % height

    calculateBackgroundPosition: ->
      type = @model.get "type"
      roadType = @model.get "roadType"

      if roadType is 0
        @backgroundPositionX = 0 - ((type % 16) * 16)
        @backgroundPositionY = 0 - (~~(type / 16) * 16)
      else
        roadTileType = @calculateRoadTile()

        @backgroundPositionX = 0 - roadTileType * 16
        @backgroundPositionY = 0 - 256

    calculateRoadTile: ->
      x = @model.get "x"
      y = @model.get "y"

      n = heightmap.get("data")[@clampY y - 1][x].get "roadType"
      e = heightmap.get("data")[y][@clampX x + 1].get "roadType"
      s = heightmap.get("data")[@clampY y + 1][x].get "roadType"
      w = heightmap.get("data")[y][@clampX x - 1].get "roadType"

      a = n << n * 4 - 4
      b = e << e * 4 - 3
      c = s << s * 4 - 2
      d = w << w * 4 - 1

      t = a + b + c + d

    setListeners: ->
      @listenTo @model, "change:roadType", @render

      @listenTo @model, "neighborRoadChanged", @render

    setBackgroundPosition: ->
      @$el.css
        backgroundPosition: "#{@backgroundPositionX}px #{@backgroundPositionY}px"

      @
