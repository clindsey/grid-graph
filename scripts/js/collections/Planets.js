(function() {

  define(["models/Planet", "Backbone"], function(PlanetModel) {
    var Planets;
    Planets = Backbone.Collection.extend({
      model: PlanetModel
    });
    return new Planets;
  });

}).call(this);
