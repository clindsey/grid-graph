(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var Mine;
    return Mine = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        cost: 60,
        value: 5
      }
    });
  });

}).call(this);
