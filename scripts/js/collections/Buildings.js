(function() {

  define(["models/buildings/Building", "Backbone", "localstorage"], function(BuildingModel) {
    var Buildings;
    Buildings = Backbone.Collection.extend({
      model: BuildingModel,
      localStorage: new Backbone.LocalStorage("Buildings")
    });
    return new Buildings;
  });

}).call(this);
