(function() {

  define(["models/Planet", "collections/Planets", "Alea", "Backbone"], function(PlanetModel, planets) {
    var Galaxy;
    return Galaxy = Backbone.Model.extend({
      defaults: {
        seed: 1364432313865,
        size: 256
      },
      generate: function() {
        var index, planet, planetModels, random, _i, _ref;
        random = new Alea(this.get("seed"));
        planetModels = [];
        for (index = _i = 1, _ref = this.get("size"); 1 <= _ref ? _i <= _ref : _i >= _ref; index = 1 <= _ref ? ++_i : --_i) {
          planet = new PlanetModel({
            seed: ~~(random() * 0xffffff)
          });
          planetModels.push(planet);
        }
        planets.reset(planetModels);
        return planets.first().activate();
      }
    });
  });

}).call(this);
