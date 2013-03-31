(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Workable;
    return Workable = BuildingModel.extend({
      defaults: {
        needsWorker: true,
        cost: 0,
        value: 0
      },
      initialize: function() {
        BuildingModel.prototype.initialize.call(this);
        return this.listenTo(this, "worked", this.onWorked);
      },
      onWorked: function() {
        return this.trigger("madeMoney", this.get("value"));
      }
    });
  });

}).call(this);
