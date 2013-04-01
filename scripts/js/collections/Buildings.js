(function() {

  define(["models/buildings/Building", "collections/Planets", "Backbone", "localstorage"], function(BuildingModel, planets) {
    var Buildings;
    Buildings = Backbone.Collection.extend({
      model: BuildingModel,
      initialize: function() {
        return this.listenTo(planets, "active", this.onPlanetActive);
      },
      onPlanetActive: function(activePlanet) {
        return this.localStorage = new Backbone.LocalStorage("Buildings-" + (activePlanet.get("seed")));
      }
    });
    return new Buildings;
  });

}).call(this);
