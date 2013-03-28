(function() {

  define(["models/NameMaker", "Backbone"], function(nameMaker) {
    var Planet;
    return Planet = Backbone.Model.extend({
      defaults: {
        seed: 1364432313865,
        name: "Unnamed"
      },
      initialize: function() {
        return this.set("name", nameMaker.getName(this.get("seed")));
      },
      activate: function() {
        return this.trigger("active", this);
      }
    });
  });

}).call(this);
