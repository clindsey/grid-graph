(function() {

  define(["Backbone"], function() {
    var MapTile;
    return MapTile = Backbone.Model.extend({
      defaults: {
        type: 0,
        isOccupied: false,
        buildingView: void 0
      },
      initialize: function() {
        return this.listenTo(this, "change:buildingView", this.setOccupied);
      },
      setOccupied: function() {
        var buildingType;
        buildingType = this.get("buildingView");
        if (buildingType != null) {
          return this.set("isOccupied", true);
        } else {
          return this.set("isOccupied", false);
        }
      }
    });
  });

}).call(this);
