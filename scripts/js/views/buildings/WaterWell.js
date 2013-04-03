(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var WaterWell;
    return WaterWell = WorkableView.extend({
      backgroundPositionX: -192 * 2,
      backgroundPositionY: -272 * 2
    });
  });

}).call(this);
