define [
      "models/heightmap/HeightmapChunk"
      "models/MapTile"
      "collections/MapTiles"
      "Alea"
      "Backbone"
    ], (
      HeightmapChunkModel,
      MapTileModel,
      mapTiles) ->

  Heightmap = Backbone.Model.extend
    initialize: ->
      @set "SEED", +new Date

      worldChunkWidth = 8
      worldChunkHeight = 8
      chunkWidth = 9
      chunkHeight = 9
      maxElevation = 10

      @set
        worldTileWidth: worldChunkWidth * chunkWidth
        worldTileHeight: worldChunkHeight * chunkHeight

      chunks = @buildChunks worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation
      heightmap = @generateHeightmap chunks, worldChunkWidth * chunkWidth, worldChunkHeight * chunkHeight, chunkWidth, chunkHeight, maxElevation
      @set "data", @processTiles heightmap

    processTiles: (heightmap) ->
      data = []
      newMapTiles = []
      xl = @get "worldTileWidth"
      yl = @get "worldTileHeight"
      cx = (x) => @clamp x, xl
      cy = (y) => @clamp y, yl

      for y in [0..yl - 1]
        data[y] = []

        for x in [0..xl - 1]
          n = heightmap[cy y - 1][x]
          e = heightmap[y][cx x + 1]
          s = heightmap[cy y + 1][x]
          w = heightmap[y][cx x - 1]
          ne = heightmap[cy y - 1][cx x + 1]
          se = heightmap[cy y + 1][cx x + 1]
          sw = heightmap[cy y + 1][cx x - 1]
          nw = heightmap[cy y - 1][cx x - 1]

          o = heightmap[y][x]

          if o is 0
            s = 0
          else
            a = n << n * 4
            b = e << e * 5
            c = s << s * 6
            d = w << w * 7
            e = ne << ne * 0
            f = se << se * 1
            g = nw << nw * 3
            h = sw << sw * 2

            s = a + b + c + d + e + f + g + h

          mapTileModel = new MapTileModel(
              type: s
              x: x
              y: y)

          data[y][x] = mapTileModel

          newMapTiles.push mapTileModel

      mapTiles.reset newMapTiles

      data

    clamp: (index, size) ->
      (index + size) % size

    clampX: (x) ->
      width = @get "worldTileWidth"

      (x + width) % width

    clampY: (y) ->
      height = @get "worldTileHeight"

      (y + height) % height

    getNeighboringTiles: (x, y) ->
      heightmapData = @get "data"

      {
        n: heightmapData[@clampY y - 1][x]
        e: heightmapData[y][@clampX x + 1]
        s: heightmapData[@clampY y + 1][x]
        w: heightmapData[y][@clampX x - 1]
      }

    generateHeightmap: (chunks, worldTileWidth, worldTileHeight, chunkWidth, chunkHeight, maxElevation) ->
      heightmap = []

      for chunkRow, y in chunks
        for chunk, x in chunkRow
          cells = chunk.get "cells"

          for cellRow, cy in cells
            for cell, cx in cellRow
              yIndex = cy + (y * cells.length)
              xIndex = cx + (x * cellRow.length)

              heightmap[yIndex] = [] unless heightmap[yIndex]?
              heightmap[yIndex][xIndex] = @tileHeightToType cell, maxElevation

      heightmap

    tileHeightToType: (height, maxElevation) ->
      if height / maxElevation >= 0.5
        type = 1
      else
        type = 0

      type

    buildChunks: (worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation) ->
      SEED = @get "SEED"

      worldTileWidth = worldChunkWidth * chunkWidth

      chunks = []

      for y in [0..worldChunkHeight - 1]
        chunks[y] = []

        for x in [0..worldChunkWidth - 1]
          nw = (new Alea(y * worldTileWidth + x + SEED))() * maxElevation

          if x + 1 is worldChunkWidth
            ne = (new Alea(y * worldTileWidth + SEED))() * maxElevation
          else
            ne = (new Alea(y * worldTileWidth + x + 1 + SEED))() * maxElevation

          if y + 1 is worldChunkHeight
            sw = (new Alea(x + SEED))() * maxElevation

            if x + 1 is worldChunkWidth
              se = (new Alea(SEED)()) * maxElevation
            else
              se = (new Alea(x + 1 + SEED))() * maxElevation
          else
            sw = (new Alea((y + 1) * worldTileWidth + x + SEED))() * maxElevation

            if x + 1 is worldChunkWidth
              se = (new Alea((y + 1) * worldTileWidth + SEED))() * maxElevation
            else
              se = (new Alea((y + 1) * worldTileWidth + x + 1 + SEED))() * maxElevation

          chunks[y][x] = new HeightmapChunkModel
            ne: ne
            nw: nw
            se: se
            sw: sw
            width: chunkWidth
            height: chunkHeight

      chunks

    getArea: (sliceWidth, sliceHeight, centerX, centerY) ->
      dataOut = []

      heightmapData = @get "data"
      dataHeight = heightmapData.length
      xOffset = sliceWidth >> 1
      yOffset = sliceHeight >> 1

      for y in [0..sliceHeight - 1]
        dataWidth = heightmapData[y].length
        dataOut[y] = []

        for x in [0..sliceWidth - 1]
          xIndex = @clamp x - xOffset + centerX, dataWidth
          yIndex = @clamp y - yOffset + centerY, dataHeight

          dataOut[y][x] = heightmapData[yIndex][xIndex]

      dataOut

    getPathfindingGrid: (sliceWidth, sliceHeight, centerX, centerY) ->
      tileGrid = @getArea sliceWidth, sliceHeight, centerX, centerY

      dataOut = []

      for tileGridRow, y in tileGrid
        dataOut[y] = []

        for tileGridItem, x in tileGridRow
          dataOut[y][x] = +!(tileGridItem.get "isOccupied")

      dataOut

  new Heightmap
