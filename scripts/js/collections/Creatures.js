(function() {

  define(["models/entities/Creature", "Backbone", "localstorage"], function(CreatureModel) {
    var Creatures;
    Creatures = Backbone.Collection.extend({
      model: CreatureModel,
      localStorage: new Backbone.LocalStorage("Creatures")
    });
    return new Creatures;
  });

}).call(this);
