var d3 = require('d3')
var convention = require('d3-convention')

var genderDistributionGraphic = require('./graphics/gender-distribution')

var genderDist = convention({
  svg: window.document.getElementById('gender-distribution')
})

d3.csv('artists-purchases.csv')
.row(function (d) {
  return {
    id: d.id,
    gender: d.gender,
    year: +d.year
  }
})
.get(function (err, data) {
  if (err) return console.error(err)

  genderDistributionGraphic(genderDist, data)
})
