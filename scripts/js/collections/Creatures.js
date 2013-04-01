(function() {

  define(["models/entities/Creature", "collections/Planets", "Backbone", "localstorage"], function(CreatureModel, planets) {
    var Creatures;
    Creatures = Backbone.Collection.extend({
      model: CreatureModel,
      initialize: function() {
        return this.listenTo(planets, "active", this.onPlanetActive);
      },
      onPlanetActive: function(activePlanet) {
        return this.localStorage = new Backbone.LocalStorage("Creatures-" + (activePlanet.get("seed")));
      }
    });
    return new Creatures;
  });

}).call(this);
