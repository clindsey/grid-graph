(function() {

  define(["Backbone"], function() {
    var Building;
    return Building = Backbone.Model.extend({
      defaults: {
        type: "Building",
        needsWorker: false,
        resources: {
          wood: 0,
          food: 0,
          metal: 0
        }
      },
      initialize: function() {}
    });
  });

}).call(this);
