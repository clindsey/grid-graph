(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Mine;
    return Mine = WorkableView.extend({
      backgroundPositionX: -16 * 2,
      backgroundPositionY: -272 * 2
    });
  });

}).call(this);
