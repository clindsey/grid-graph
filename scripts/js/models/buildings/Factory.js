// Generated by CoffeeScript 1.4.0
(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var Factory;
    return Factory = WorkableModel.extend({
      defaults: {
        needsWorker: true,
        cost: 60,
        value: 5
      }
    });
  });

}).call(this);
