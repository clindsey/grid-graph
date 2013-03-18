// Generated by CoffeeScript 1.4.0
(function() {

  define(["collections/Buildings", "Backbone"], function(buildings) {
    var Overview;
    Overview = Backbone.Model.extend({
      defaults: {
        money: 250
      },
      initialize: function() {
        return this.listenTo(buildings, "madeMoney", this.onMadeMoney);
      },
      onMadeMoney: function(amount) {
        var money;
        money = this.get("money");
        money += amount;
        return this.set("money", money);
      },
      removeMoney: function(amount) {
        var money;
        money = this.get("money");
        money -= amount;
        return this.set("money", money);
      },
      purchase: function(amount) {
        if (this.get("money") < amount) {
          return false;
        }
        this.removeMoney(amount);
        return true;
      }
    });
    return new Overview;
  });

}).call(this);
