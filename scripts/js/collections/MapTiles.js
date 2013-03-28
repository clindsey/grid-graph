(function() {

  define(["models/MapTile", "Backbone"], function(MapTileModel) {
    var MapTiles;
    MapTiles = Backbone.Collection.extend({
      model: MapTileModel
    });
    return new MapTiles;
  });

}).call(this);
