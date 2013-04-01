(function() {

  define(["views/buildings/Workable", "Backbone"], function(WorkableView) {
    var Farm;
    return Farm = WorkableView.extend({
      backgroundPositionX: -32,
      backgroundPositionY: -272,
      calculateBackgroundPosition: function() {
        return this.backgroundPositionX = 0 - 32 - (3 * 16);
      }
    });
  });

}).call(this);
