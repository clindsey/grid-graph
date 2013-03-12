// Generated by CoffeeScript 1.4.0
(function() {

  define(["views/entities/Entity", "models/Heightmap"], function(EntityView, heightmapModel) {
    var Creature;
    return Creature = EntityView.extend({
      className: "creature-tile creature-moving entity-tile",
      initialize: function() {
        return this.listenTo(this.model, "remove", this.remove);
      },
      render: function() {
        EntityView.prototype.render.call(this);
        return this;
      }
    });
  });

}).call(this);