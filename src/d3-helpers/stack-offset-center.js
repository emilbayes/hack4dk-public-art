'use strict'

/**
 * Center the layers around a central axis, growing to either side.
 * Currently only works for two layers
 */
module.exports = function (data) {
  var layers = data.length
  var points = data[0].length
  var max = 0
  var i, j, s

  for (j = 0; j < points; ++j) {
    for (i = 0, s = 0; i < layers; i++) s += data[i][j][1]
    if (s > max) max = s
  }

  var y0 = []
  for (j = 0; j < points; ++j) {
    y0[j] = max / 2 - data[0][j][1]
  }

  return y0
}
