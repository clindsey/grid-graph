(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Road;
    return Road = BuildingModel.extend({
      defaults: {
        type: "Road",
        needsWorker: false,
        resources: {
          wood: 5,
          food: 0,
          metal: 0
        }
      },
      initialize: function() {
        return BuildingModel.prototype.initialize.call(this);
      }
    });
  });

}).call(this);
