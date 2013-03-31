(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var Factory;
    return Factory = WorkableModel.extend({
      defaults: {
        type: "Factory",
        needsWorker: true,
        resources: {
          wood: 20,
          food: 10,
          metal: 20
        }
      }
    });
  });

}).call(this);
