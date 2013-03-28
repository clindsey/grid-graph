(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var Mine;
    return Mine = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        resources: {
          wood: 20,
          food: 10,
          metal: 0
        },
        production: {
          wood: 0,
          food: 0,
          metal: 10
        }
      }
    });
  });

}).call(this);
