(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var LumberMill;
    return LumberMill = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        cost: 60,
        value: 5
      }
    });
  });

}).call(this);
