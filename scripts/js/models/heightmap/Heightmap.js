(function() {

  define(["models/heightmap/HeightmapChunk", "models/MapTile", "collections/MapTiles", "collections/Planets", "Alea", "Backbone"], function(HeightmapChunkModel, MapTileModel, mapTiles, planets) {
    var Heightmap;
    Heightmap = Backbone.Model.extend({
      initialize: function() {
        return this.listenTo(planets, "active", this.generateData);
      },
      generateData: function(activePlanet) {
        var chunkHeight, chunkWidth, chunks, heightmap, maxElevation, worldChunkHeight, worldChunkWidth;
        this.set("SEED", activePlanet.get("seed"));
        worldChunkWidth = 8;
        worldChunkHeight = 8;
        chunkWidth = 9;
        chunkHeight = 9;
        maxElevation = 10;
        this.set({
          worldTileWidth: worldChunkWidth * chunkWidth,
          worldTileHeight: worldChunkHeight * chunkHeight
        });
        chunks = this.buildChunks(worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation);
        heightmap = this.generateHeightmap(chunks, worldChunkWidth * chunkWidth, worldChunkHeight * chunkHeight, chunkWidth, chunkHeight, maxElevation);
        return this.set("data", this.processTiles(heightmap));
      },
      processTiles: function(heightmap) {
        var a, b, c, cx, cy, d, data, e, f, g, h, mapTileModel, n, ne, newMapTiles, nw, o, rnd, s, se, sw, w, x, xl, y, yl, _i, _j, _ref, _ref1,
          _this = this;
        rnd = new Alea(this.get("SEED"));
        data = [];
        newMapTiles = [];
        xl = this.get("worldTileWidth");
        yl = this.get("worldTileHeight");
        cx = function(x) {
          return _this.clamp(x, xl);
        };
        cy = function(y) {
          return _this.clamp(y, yl);
        };
        for (y = _i = 0, _ref = yl - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
          data[y] = [];
          for (x = _j = 0, _ref1 = xl - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            n = heightmap[cy(y - 1)][x];
            e = heightmap[y][cx(x + 1)];
            s = heightmap[cy(y + 1)][x];
            w = heightmap[y][cx(x - 1)];
            ne = heightmap[cy(y - 1)][cx(x + 1)];
            se = heightmap[cy(y + 1)][cx(x + 1)];
            sw = heightmap[cy(y + 1)][cx(x - 1)];
            nw = heightmap[cy(y - 1)][cx(x - 1)];
            o = heightmap[y][x];
            if (o === 0) {
              s = 0;
            } else {
              a = n << n * 4;
              b = e << e * 5;
              c = s << s * 6;
              d = w << w * 7;
              e = ne << ne * 0;
              f = se << se * 1;
              g = nw << nw * 3;
              h = sw << sw * 2;
              s = a + b + c + d + e + f + g + h;
            }
            mapTileModel = new MapTileModel({
              type: s,
              x: x,
              y: y,
              seed: rnd()
            });
            data[y][x] = mapTileModel;
            newMapTiles.push(mapTileModel);
          }
        }
        mapTiles.reset(newMapTiles);
        return data;
      },
      clamp: function(index, size) {
        return (index + size) % size;
      },
      clampX: function(x) {
        var width;
        width = this.get("worldTileWidth");
        return (x + width) % width;
      },
      clampY: function(y) {
        var height;
        height = this.get("worldTileHeight");
        return (y + height) % height;
      },
      getNeighboringTiles: function(x, y) {
        var heightmapData;
        heightmapData = this.get("data");
        return {
          n: heightmapData[this.clampY(y - 1)][x],
          e: heightmapData[y][this.clampX(x + 1)],
          s: heightmapData[this.clampY(y + 1)][x],
          w: heightmapData[y][this.clampX(x - 1)]
        };
      },
      generateHeightmap: function(chunks, worldTileWidth, worldTileHeight, chunkWidth, chunkHeight, maxElevation) {
        var cell, cellRow, cells, chunk, chunkRow, cx, cy, heightmap, x, xIndex, y, yIndex, _i, _j, _k, _l, _len, _len1, _len2, _len3;
        heightmap = [];
        for (y = _i = 0, _len = chunks.length; _i < _len; y = ++_i) {
          chunkRow = chunks[y];
          for (x = _j = 0, _len1 = chunkRow.length; _j < _len1; x = ++_j) {
            chunk = chunkRow[x];
            cells = chunk.get("cells");
            for (cy = _k = 0, _len2 = cells.length; _k < _len2; cy = ++_k) {
              cellRow = cells[cy];
              for (cx = _l = 0, _len3 = cellRow.length; _l < _len3; cx = ++_l) {
                cell = cellRow[cx];
                yIndex = cy + (y * cells.length);
                xIndex = cx + (x * cellRow.length);
                if (heightmap[yIndex] == null) {
                  heightmap[yIndex] = [];
                }
                heightmap[yIndex][xIndex] = this.tileHeightToType(cell, maxElevation);
              }
            }
          }
        }
        return heightmap;
      },
      tileHeightToType: function(height, maxElevation) {
        var type;
        if (height / maxElevation >= 0.5) {
          type = 1;
        } else {
          type = 0;
        }
        return type;
      },
      buildChunks: function(worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation) {
        var SEED, chunks, ne, nw, se, sw, worldTileWidth, x, y, _i, _j, _ref, _ref1;
        SEED = this.get("SEED");
        worldTileWidth = worldChunkWidth * chunkWidth;
        chunks = [];
        for (y = _i = 0, _ref = worldChunkHeight - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
          chunks[y] = [];
          for (x = _j = 0, _ref1 = worldChunkWidth - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            nw = (new Alea(y * worldTileWidth + x + SEED))() * maxElevation;
            if (x + 1 === worldChunkWidth) {
              ne = (new Alea(y * worldTileWidth + SEED))() * maxElevation;
            } else {
              ne = (new Alea(y * worldTileWidth + x + 1 + SEED))() * maxElevation;
            }
            if (y + 1 === worldChunkHeight) {
              sw = (new Alea(x + SEED))() * maxElevation;
              if (x + 1 === worldChunkWidth) {
                se = (new Alea(SEED)()) * maxElevation;
              } else {
                se = (new Alea(x + 1 + SEED))() * maxElevation;
              }
            } else {
              sw = (new Alea((y + 1) * worldTileWidth + x + SEED))() * maxElevation;
              if (x + 1 === worldChunkWidth) {
                se = (new Alea((y + 1) * worldTileWidth + SEED))() * maxElevation;
              } else {
                se = (new Alea((y + 1) * worldTileWidth + x + 1 + SEED))() * maxElevation;
              }
            }
            chunks[y][x] = new HeightmapChunkModel({
              ne: ne,
              nw: nw,
              se: se,
              sw: sw,
              width: chunkWidth,
              height: chunkHeight
            });
          }
        }
        return chunks;
      },
      getArea: function(sliceWidth, sliceHeight, centerX, centerY) {
        var dataHeight, dataOut, dataWidth, heightmapData, x, xIndex, xOffset, y, yIndex, yOffset, _i, _j, _ref, _ref1;
        dataOut = [];
        heightmapData = this.get("data");
        dataHeight = heightmapData.length;
        xOffset = sliceWidth >> 1;
        yOffset = sliceHeight >> 1;
        for (y = _i = 0, _ref = sliceHeight - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
          dataWidth = heightmapData[y].length;
          dataOut[y] = [];
          for (x = _j = 0, _ref1 = sliceWidth - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            xIndex = this.clamp(x - xOffset + centerX, dataWidth);
            yIndex = this.clamp(y - yOffset + centerY, dataHeight);
            dataOut[y][x] = heightmapData[yIndex][xIndex];
          }
        }
        return dataOut;
      },
      getPathfindingGrid: function(sliceWidth, sliceHeight, centerX, centerY) {
        var dataOut, tileGrid, tileGridItem, tileGridRow, x, y, _i, _j, _len, _len1;
        tileGrid = this.getArea(sliceWidth, sliceHeight, centerX, centerY);
        dataOut = [];
        for (y = _i = 0, _len = tileGrid.length; _i < _len; y = ++_i) {
          tileGridRow = tileGrid[y];
          dataOut[y] = [];
          for (x = _j = 0, _len1 = tileGridRow.length; _j < _len1; x = ++_j) {
            tileGridItem = tileGridRow[x];
            dataOut[y][x] = +(!(tileGridItem.get("isOccupied")));
          }
        }
        return dataOut;
      }
    });
    return new Heightmap;
  });

}).call(this);
