(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Factory;
    return Factory = WorkableView.extend({
      backgroundPositionX: -160 * 2,
      backgroundPositionY: -272 * 2
    });
  });

}).call(this);
