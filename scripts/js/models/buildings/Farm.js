(function() {

  define(["models/buildings/Workable", "collections/ViewportTiles", "Backbone"], function(WorkableModel, viewportTiles) {
    var Farm;
    return Farm = WorkableModel.extend({
      defaults: {
        type: "Farm",
        needsWorker: true,
        stage: 0,
        resources: {
          wood: 20,
          food: 0,
          metal: 0
        },
        production: {
          wood: 0,
          food: 5,
          metal: 0
        }
      }
    });
  });

}).call(this);
