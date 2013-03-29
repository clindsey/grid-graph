(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Home;
    return Home = BuildingModel.extend({
      defaults: {
        type: "Home",
        needsWorker: false,
        resources: {
          wood: 20,
          food: 10,
          metal: 0
        }
      },
      initialize: function() {
        return BuildingModel.prototype.initialize.call(this);
      }
    });
  });

}).call(this);
