(function() {

  define(["models/heightmap/Heightmap", "collections/ViewportTiles", "Backbone"], function(heightmapModel, viewportTiles) {
    var Viewport;
    Viewport = Backbone.Model.extend({
      defaults: {
        x: 0,
        y: 0,
        width: 32,
        height: 18
      },
      initialize: function() {
        this.listenTo(this, "change:x", this.updateTiles);
        this.listenTo(this, "change:y", this.updateTiles);
        return this.listenTo(heightmapModel, "change:data", this.updateTiles);
      },
      updateTiles: function() {
        var tile, tileRow, viewportX, viewportY, _i, _j, _len, _len1, _ref;
        viewportX = heightmapModel.clampX(this.get("x"));
        viewportY = heightmapModel.clampY(this.get("y"));
        this.set({
          x: viewportX,
          y: viewportY
        });
        viewportTiles.remove(viewportTiles.models);
        _ref = heightmapModel.getArea(this.get("width"), this.get("height"), viewportX, viewportY);
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
