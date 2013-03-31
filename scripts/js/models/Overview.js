(function() {

  define(["collections/Buildings", "Backbone"], function(buildings) {
    var Overview;
    Overview = Backbone.Model.extend({
      defaults: {
        wood: 250,
        food: 100,
        metal: 0
      },
      initialize: function() {
        return this.listenTo(buildings, "madeResources", this.onMadeResources);
      },
      onMadeResources: function(resources) {
        var foodCount, metalCount, woodCount;
        woodCount = this.get("wood");
        woodCount += resources.wood;
        this.set("wood", woodCount);
        foodCount = this.get("food");
        foodCount += resources.food;
        this.set("food", foodCount);
        metalCount = this.get("metal");
        metalCount += resources.metal;
        return this.set("metal", metalCount);
      },
      removeResources: function(resources) {
        var foodCount, metalCount, woodCount;
        woodCount = this.get("wood");
        woodCount -= resources.wood;
        this.set("wood", woodCount);
        foodCount = this.get("food");
        foodCount -= resources.food;
        this.set("food", foodCount);
        metalCount = this.get("metal");
        metalCount -= resources.metal;
        return this.set("metal", metalCount);
      },
      purchase: function(resources) {
        if (this.get("wood") < resources.wood) {
          return false;
        }
        if (this.get("food") < resources.food) {
          return false;
        }
        if (this.get("metal") < resources.metal) {
          return false;
        }
        this.removeResources(resources);
        return true;
      }
    });
    return new Overview;
  });

}).call(this);
