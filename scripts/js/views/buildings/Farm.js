(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Farm;
    return Farm = WorkableView.extend({
      backgroundPositionX: -160,
      backgroundPositionY: -576
    });
  });

}).call(this);
