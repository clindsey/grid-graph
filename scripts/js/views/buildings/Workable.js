(function() {

  define(["Backbone"], function() {
    var Workable;
    return Workable = Backbone.View.extend({
      backgroundPositionX: 0,
      backgroundPositionY: 0,
      initialize: function() {
        this.listenTo(this.model, "calculateBackgroundPosition", this.calculateBackgroundPosition);
        return this.calculateBackgroundPosition;
      },
      calculateBackgroundPosition: function() {},
      render: function() {}
    });
  });

}).call(this);
