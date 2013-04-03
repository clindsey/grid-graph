(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Farm;
    return Farm = WorkableView.extend({
      backgroundPositionX: -80 * 2,
      backgroundPositionY: -272 * 2
    });
  });

}).call(this);
