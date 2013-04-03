(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var LumberMill;
    return LumberMill = WorkableView.extend({
      backgroundPositionX: -208 * 2,
      backgroundPositionY: -272 * 2
    });
  });

}).call(this);
