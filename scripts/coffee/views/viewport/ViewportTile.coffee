define [
      "models/Heightmap"
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

    clampX: (x) ->
      width = heightmapModel.get "worldTileWidth"

      (x + width) % width

    clampY: (y) ->
      height = heightmapModel.get "worldTileHeight"

      (y + height) % height

    calculateBackgroundPosition: ->
      type = @model.get "type"
      roadType = @model.get "roadType"
      buildingType = @model.get "buildingType"

      unless roadType is 0
        roadTileType = @calculateRoadTile()

        @backgroundPositionX = 0 - roadTileType * 16
        @backgroundPositionY = 0 - 256
      else unless buildingType is 0
        @backgroundPositionX = 0 - (buildingType - 1) * 16
        @backgroundPositionY = 0 - 272
      else
        @backgroundPositionX = 0 - ((type % 16) * 16)
        @backgroundPositionY = 0 - (~~(type / 16) * 16)

    calculateRoadTile: ->
      x = @model.get "x"
      y = @model.get "y"

      heightmapData = heightmapModel.get "data"

      n = heightmapData[@clampY y - 1][x].get "isOccupied"
      e = heightmapData[y][@clampX x + 1].get "isOccupied"
      s = heightmapData[@clampY y + 1][x].get "isOccupied"
      w = heightmapData[y][@clampX x - 1].get "isOccupied"

      a = n << n * 4 - 4
      b = e << e * 4 - 3
      c = s << s * 4 - 2
      d = w << w * 4 - 1

      t = a + b + c + d

    setListeners: ->
      @listenTo @model, "change:isOccupied", @render

      @listenTo @model, "neighborChanged", @render

    setBackgroundPosition: ->
      @$el.css
        backgroundPosition: "#{@backgroundPositionX}px #{@backgroundPositionY}px"

      @
