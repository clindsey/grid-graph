(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    return WorkableModel = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        cost: 60,
        value: 5
      }
    });
  });

}).call(this);
