(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    return WorkableModel = WorkableModel.extend({
      defaults: {
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
