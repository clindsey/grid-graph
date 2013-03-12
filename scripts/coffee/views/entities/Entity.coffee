define [
      "models/Viewport"
      "models/Heightmap"
      "Backbone"
    ], (
      viewportModel,
      heightmapModel) ->

  Entity = Backbone.View.extend
    tagName: "div"

    className: "entity-tile"

    initialize: ->
      @listenTo viewportModel, "moved", @onViewportMoved

      @listenTo @model, "change:x", @onMove
      @listenTo @model, "change:y", @onMove

    render: ->
      @setPosition()

      @

    onMove: ->
      @setPosition()

    onViewportMoved: ->
      @setPosition()

    setPosition: ->
      centerX = ~~(viewportModel.get("width") / 2)
      centerY = ~~(viewportModel.get("height") / 2)

      viewX = viewportModel.get "x"
      viewY = viewportModel.get "y"

      myX = @model.get "x"
      myY = @model.get "y"

      x = (myX - viewX) + centerX
      y = (myY - viewY) + centerY

      worldWidth = heightmapModel.get "worldTileWidth"
      halfWorldWidth = ~~(worldWidth / 2)

      worldHeight = heightmapModel.get "worldTileHeight"
      halfWorldHeight = ~~(worldHeight / 2)

      offsetX = 0
      offsetY = 0

      if myX > viewX + halfWorldWidth
        offsetX -= worldWidth

      if myX < viewX - halfWorldWidth
        offsetX += worldWidth

      if myY > viewY + halfWorldHeight
        offsetY -= worldHeight

      if myY < viewY - halfWorldHeight
        offsetY += worldHeight

      @$el.css
        left: (x + offsetX) * 16
        top: (y + offsetY) * 16
