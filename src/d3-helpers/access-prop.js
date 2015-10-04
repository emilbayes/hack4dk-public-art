module.exports = function (prop, dflt) {
  return function (d) {
    return d[prop] || dflt
  }
}
