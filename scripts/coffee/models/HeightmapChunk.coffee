define [
      "Backbone"
    ], (
      ) ->

  bilinearInterpolation = (ne, nw, se, sw, width, height) ->
    x_lookup = []
    cells = []

    for y in [0..height - 1]
      cells[y] = []
      y_step = y / (height - 1)

      for x in [0..width - 1]
        if x_lookup[x]?
          x_step = x_lookup[x]
        else
          x_step = x_lookup[x] = x / (width - 1)

        top_height = nw + x_step * (ne - nw)
        bottom_height = sw + x_step * (se - sw)
        cell_height = top_height + y_step * (bottom_height - top_height)
        cells[y][x] = ~~cell_height

    cells

  HeightmapChunk = Backbone.Model.extend
    initialize: ->
      @set "cells", bilinearInterpolation(
        @get("ne"),
        @get("nw"),
        @get("se"),
        @get("sw"),
        @get("width"),
        @get("height"))
