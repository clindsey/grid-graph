(function() {

  define(["models/heightmap/Heightmap", "Backbone"], function(heightmapModel) {
    var Road;
    return Road = Backbone.View.extend({
      backgroundPositionX: 0,
      backgroundPositionY: -256,
      initialize: function() {
        var roadTileType;
        this.listenTo(this.model.get("tileModel"), "neighborChanged", this.onNeighborChanged);
        roadTileType = this.calculateRoadTile();
        return this.backgroundPositionX = 0 - roadTileType * 16;
      },
      onNeighborChanged: function() {
        var roadTileType;
        roadTileType = this.calculateRoadTile();
        this.backgroundPositionX = 0 - roadTileType * 16;
        return this.listenTo(this.model.get("tileModel").trigger("updateBackgroundPosition"));
      },
      calculateRoadTile: function() {
        var a, b, c, d, e, n, neighboringTiles, s, t, w, x, y;
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
        return t = a + b + c + d;
      }
    });
  });

}).call(this);
