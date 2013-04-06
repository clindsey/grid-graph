(function() {

  define(["views/entities/Entity", "models/heightmap/Heightmap"], function(EntityView, heightmapModel) {
    var Creature;
    return Creature = EntityView.extend({
      className: "creature-tile entity-tile",
      initialize: function() {
        EntityView.prototype.initialize.call(this);
        this.listenTo(this.model, "change:stateIdentifier", this.onStateChange);
        this.listenTo(this.model, "change:direction", this.onDirectionChange);
        this.listenTo(this.model, "step", this.onStep);
        this.currentState = this.model.get("stateIdentifier");
        this.currentDirection = this.model.get("direction");
        return this.setClassName();
      },
      onStateChange: function() {
        this.removeClassName();
        this.currentState = this.model.get("stateIdentifier");
        return this.setClassName();
      },
      onDirectionChange: function() {
        this.removeClassName();
        this.currentDirection = this.model.get("direction");
        return this.setClassName();
      },
      removeClassName: function() {
        return this.$el.removeClass("" + this.currentState + "-" + this.currentDirection);
      },
      setClassName: function() {
        return this.$el.addClass("" + this.currentState + "-" + this.currentDirection);
      },
      onStep: function(vector) {
        this.$el.css({
          "margin-left": 0 - vector[0] * (16 * 2),
          "margin-top": 0 - vector[1] * (16 * 2)
        });
        return this.$el.animate({
          "margin-left": 0,
          "margin-top": 0
        }, {
          duration: 950,
          easing: "linear"
        });
      }
    });
  });

}).call(this);
