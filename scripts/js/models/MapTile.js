// Generated by CoffeeScript 1.4.0
(function() {

  define(["Backbone"], function() {
    var MapTile;
    return MapTile = Backbone.Model.extend({
      defaults: {
        type: 0,
        isOccupied: false,
        roadType: 0,
        buildingType: 0
      },
      initialize: function() {
        this.listenTo(this, "change:roadType", this.setOccupied);
        return this.listenTo(this, "change:buildingType", this.setOccupied);
      },
      setOccupied: function() {
        if (this.roadType === 0 && this.buildingType === 0) {
          return this.set("isOccupied", false);
        } else {
          return this.set("isOccupied", true);
        }
      },
      removeOccupant: function() {
        this.set("roadType", 0);
        this.set("buildingType", 0);
        return this.set("isOccupied", false);
      }
    });
  });

}).call(this);