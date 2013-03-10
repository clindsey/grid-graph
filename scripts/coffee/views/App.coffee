define [
      "views/viewport/Viewport"
      "models/Viewport"
      "Backbone"
    ], (
      ViewportView,
      viewportModel) ->

  AppView = Backbone.View.extend
    el: document

    events:
      "keydown": "onKeyDown"

    initialize: ->
      new ViewportView

    onKeyDown: (jqEvent) ->
      viewportX = viewportModel.get "x"
      viewportY = viewportModel.get "y"

      vx = 0
      vy = 0

      if jqEvent.keyCode is 37 # left
        vx -= 1
      else if jqEvent.keyCode is 38 # up
        vy -= 1
      else if jqEvent.keyCode is 39 # right
        vx += 1
      else if jqEvent.keyCode is 40 # down
        vy += 1

      viewportModel.set
        x: viewportX + vx
        y: viewportY + vy

      unless vx is 0 and vy is 0
        jqEvent.preventDefault()
        jqEvent.stopPropagation()
        return false
