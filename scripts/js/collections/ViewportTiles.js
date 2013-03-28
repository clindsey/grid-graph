(function() {

  define(["models/MapTile", "Backbone"], function(MapTileModel) {
    var ViewportTiles;
    ViewportTiles = Backbone.Collection.extend({
      model: MapTileModel
    });
    return new ViewportTiles;
  });

}).call(this);
