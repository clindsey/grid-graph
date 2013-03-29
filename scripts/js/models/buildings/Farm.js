(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
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
          food: 45,
          metal: 0
        }
      },
      onWorked: function() {
        var newStage;
        newStage = (this.get("stage") + 1) % 4;
        this.set("stage", newStage);
        if (newStage === 0) {
          this.trigger("madeResources", this.get("production"));
        }
        this.trigger("calculateBackgroundPosition");
        return this.get("tileModel").trigger("updateBackgroundPosition");
      }
    });
  });

}).call(this);
