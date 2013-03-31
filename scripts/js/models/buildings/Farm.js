(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var Farm;
    return Farm = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        stage: 0,
        cost: 10,
        value: 30
      },
      onWorked: function() {
        var newStage;
        newStage = (this.get("stage") + 1) % 4;
        this.set("stage", newStage);
        if (newStage === 0) {
          this.trigger("madeMoney", this.get("value"));
        }
        this.trigger("calculateBackgroundPosition");
        return this.get("tileModel").trigger("updateBackgroundPosition");
      }
    });
  });

}).call(this);
