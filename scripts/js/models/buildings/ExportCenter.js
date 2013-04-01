(function() {

  define(["models/buildings/Workable", "Backbone"], function(WorkableModel) {
    var ExportCenter;
    return ExportCenter = WorkableModel.extend({
      defaults: {
        type: "ExportCenter",
        needsWorker: false
      }
    });
  });

}).call(this);
