(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Home;
    return Home = BuildingModel.extend({
      defaults: {
        cost: 25,
        needsWorker: false
      },
      initialize: function() {
        return BuildingModel.prototype.initialize.call(this);
      }
    });
  });

}).call(this);
