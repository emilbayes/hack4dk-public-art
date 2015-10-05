var d3 = require('d3')
var convention = require('d3-convention')
var parallel = require('run-parallel')

var genderDistributionGraphic = require('./graphics/gender-distribution')

var genderDist = convention({
  svg: window.document.getElementById('gender-distribution')
})

parallel([
  d3.csv('artists-purchases.csv')
  .row(function (d) { return { id: d.id, gender: d.gender, year: +d.year } }).get,
  d3.csv('committee-members.csv')
  .row(function (d) { return { name: d.name, gender: d.gender, committee_id: +d.committee_id, position: d.position, start_date: new Date(d.start_date), end_date: new Date(d.end_date) } }).get
], function (err, data) {
  if (err) return console.error(err)

  data = {artistsPurchases: data[0], committeeMembers: data[1]}

  genderDistributionGraphic(genderDist, data)
})
