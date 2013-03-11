// Generated by CoffeeScript 1.4.0
(function() {

  define(["models/Heightmap", "collections/ViewportTiles", "Backbone"], function(heightmap, viewportTiles) {
    var Viewport;
    Viewport = Backbone.Model.extend({
      defaults: {
        x: 0,
        y: 0,
        width: 21,
        height: 21
      },
      initialize: function() {
        this.listenTo(this, "change:x", this.updateTiles);
        this.listenTo(this, "change:y", this.updateTiles);
        return this.updateTiles();
      },
      clamp: function(index, size) {
        return (index + size) % size;
      },
      updateTiles: function() {
        var tile, tileRow, viewportX, viewportY, _i, _j, _len, _len1, _ref;
        viewportX = this.get("x");
        viewportY = this.get("y");
        this.set({
          x: this.clamp(this.get("x"), heightmap.get("worldTileWidth")),
          y: this.clamp(this.get("y"), heightmap.get("worldTileHeight"))
        });
        viewportTiles.remove(viewportTiles.models);
        _ref = heightmap.getArea(this.get("width"), this.get("height"), this.get("x"), this.get("y"));
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tileRow = _ref[_i];
          for (_j = 0, _len1 = tileRow.length; _j < _len1; _j++) {
            tile = tileRow[_j];
            viewportTiles.add(tile);
          }
        }
        return this.trigger("moved");
      }
    });
    return new Viewport;
  });

}).call(this);