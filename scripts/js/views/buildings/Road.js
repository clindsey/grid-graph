(function() {

  define(["models/heightmap/Heightmap", "collections/ViewportTiles", "Backbone"], function(heightmapModel, viewportTiles) {
    var Road;
    return Road = Backbone.View.extend({
      backgroundPositionX: 0,
      backgroundPositionY: -256,
      initialize: function() {
        var roadTileType;
        this.listenTo(this.model, "neighborChanged", this.onNeighborChanged);
        roadTileType = this.calculateRoadTile();
        return this.backgroundPositionX = 0 - roadTileType * 16;
      },
      onNeighborChanged: function() {
        var mapTile, roadTileType;
        roadTileType = this.calculateRoadTile();
        this.backgroundPositionX = 0 - roadTileType * 16;
        mapTile = _.first(viewportTiles.where({
          x: this.model.get("x"),
          y: this.model.get("y")
        }));
        if (mapTile != null) {
          return mapTile.trigger("updateBackgroundPosition");
        }
      },
      calculateRoadTile: function() {
        var a, b, c, d, e, n, neighboringTiles, s, w, x, y;
        x = this.model.get("x");
        y = this.model.get("y");
        neighboringTiles = heightmapModel.getNeighboringTiles(x, y);
        n = neighboringTiles.n.get("isOccupied");
        e = neighboringTiles.e.get("isOccupied");
        s = neighboringTiles.s.get("isOccupied");
        w = neighboringTiles.w.get("isOccupied");
        a = n << n * 4 - 4;
        b = e << e * 4 - 3;
        c = s << s * 4 - 2;
        d = w << w * 4 - 1;
        return a + b + c + d;
      }
    });
  });

}).call(this);
