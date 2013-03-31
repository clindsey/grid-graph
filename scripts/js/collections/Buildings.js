(function() {

  define(["models/buildings/Building", "Backbone"], function(BuildingModel) {
    var Buildings;
    Buildings = Backbone.Collection.extend({
      model: BuildingModel
    });
    return new Buildings;
  });

}).call(this);
