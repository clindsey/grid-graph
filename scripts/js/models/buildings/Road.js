(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Road;
    return Road = BuildingModel.extend({
      defaults: {
        cost: 5,
        needsWorker: false
      },
      initialize: function() {
        return BuildingModel.prototype.initialize.call(this);
      }
    });
  });

}).call(this);
