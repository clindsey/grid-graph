(function() {

  define(["models/entities/Creature", "Backbone"], function(CreatureModel) {
    var Creatures;
    Creatures = Backbone.Collection.extend({
      model: CreatureModel,
      initialize: function() {}
    });
    return new Creatures;
  });

}).call(this);
