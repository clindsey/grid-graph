(function() {

  define(["Backbone"], function() {
    var HeightmapChunk, bilinearInterpolation;
    bilinearInterpolation = function(ne, nw, se, sw, width, height) {
      var bottom_height, cell_height, cells, top_height, x, x_lookup, x_step, y, y_step, _i, _j, _ref, _ref1;
      x_lookup = [];
      cells = [];
      for (y = _i = 0, _ref = height - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
        cells[y] = [];
        y_step = y / (height - 1);
        for (x = _j = 0, _ref1 = width - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
          if (x_lookup[x] != null) {
            x_step = x_lookup[x];
          } else {
            x_step = x_lookup[x] = x / (width - 1);
          }
          top_height = nw + x_step * (ne - nw);
          bottom_height = sw + x_step * (se - sw);
          cell_height = top_height + y_step * (bottom_height - top_height);
          cells[y][x] = ~~cell_height;
        }
      }
      return cells;
    };
    return HeightmapChunk = Backbone.Model.extend({
      initialize: function() {
        return this.set("cells", bilinearInterpolation(this.get("ne"), this.get("nw"), this.get("se"), this.get("sw"), this.get("width"), this.get("height")));
      }
    });
  });

}).call(this);
