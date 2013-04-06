(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Mine;
    return Mine = WorkableView.extend({
      backgroundPositionX: -32,
      backgroundPositionY: -576
    });
  });

}).call(this);
