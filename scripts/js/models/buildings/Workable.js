(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Workable;
    return Workable = BuildingModel.extend({
      defaults: {
        type: "Workable",
        needsWorker: true,
        production: {
          wood: 0,
          food: 0,
          metal: 0
        },
        resources: {
          wood: 0,
          food: 0,
          metal: 0
        }
      },
      initialize: function() {
        BuildingModel.prototype.initialize.call(this);
        return this.listenTo(this, "worked", this.onWorked);
      },
      onWorked: function() {
        return this.trigger("madeResources", this.get("production"));
      }
    });
  });

}).call(this);
