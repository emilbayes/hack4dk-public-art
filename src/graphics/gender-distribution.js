var d3 = require('d3')
var rangeInclusive = require('range-inclusive')
var o = require('fn-compose').ltr
var ƒ = require('../d3-helpers/access-prop')

var offsetCenter = require('../d3-helpers/stack-offset-center')

module.exports = function (conv, data) {
  var yearScale = d3.scale.linear()
      .domain(d3.extent(data.artistsPurchases, ƒ('year')))
			.range(conv.x.range())

  var countScale = d3.scale.linear()
			.domain([0, 600])
			.range(conv.y.range())

  var area = d3.svg.area()
    .interpolate('monotone')
    .x(o(ƒ('x'), yearScale))
		.y0(o(ƒ('y0', 0), countScale))
		.y1(function (d) { return countScale(d.y0 + d.y) })

  var line = d3.svg.line()
    .interpolate('monotone')
    .x(o(ƒ('x'), yearScale))
		.y(o(ƒ('y0', 0), countScale))

  // Bin art pieces by year
  var bin = d3.layout.histogram()
      .bins(rangeInclusive.apply(0, yearScale.domain()))
      .value(ƒ('year'))

  // Stack values, creating a common baseline
  var stack = d3.layout.stack()
      .order('reverse')
      .offset(offsetCenter) // Offset center will create a central baseline
      .values(ƒ('values'))
      .x(ƒ('x'))
      .y(ƒ('y', 0))

  // Roll up genders into bins, only considering datums with year and gender ['m', 'k']
  var genders = d3.nest()
      .key(ƒ('gender'))
      .rollup(bin)
      .entries(data.artistsPurchases
					.filter(ƒ('year'))
					.filter(function (d) { return d.gender !== 'grp' })
			)

  // Roll up committees into the start of their servance
  var committees = d3.nest()
      .key(ƒ('committee_id'))
      .rollup(function (values) {
        return d3.min(values.map(ƒ('start_date')).map(function (d) { return d.getFullYear() }))
      })
      .entries(data.committeeMembers)

  // Draw gender areas
  conv.svg.selectAll('path')
			.data(stack(genders)) // Mutates
		.enter().append('path')
			.attr('class', ƒ('key'))
			.attr('d', o(ƒ('values'), area))

  var baseline = o(ƒ('y0'), countScale)(genders[0].values[0])

  // Draw diff line
  conv.svg.append('path')
			.datum(d3.zip.apply(d3, genders.map(ƒ('values'))).map(function (d) {
        return {y0: (d[0].y - d[1].y) + d[0].y0, x: d[0].x}
      }))
      .attr({
        class: 'diff-line'
      })
      .transition()
      .duration(400)
      .attr('d', line)

  // Draw committee lines
  conv.svg.selectAll('line')
      .data(committees)
    .enter().append('line')
      .attr({
        class: 'new-committee',
        x1: o(ƒ('values'), yearScale),
        y1: countScale(600),
        x2: o(ƒ('values'), yearScale),
        y2: countScale(0)
      })

  // Axis
  var yearAxis = d3.svg.axis()
      .scale(yearScale)
      .tickSize(0)
      .tickValues([1920, 1930, 1940, 1950, 1960].concat(committees.map(ƒ('values'))))
      .tickFormat(d3.format('d'))

  conv.svg.append('g')
      .classed('axis x', true)
      .attr('transform', 'translate(0,' + baseline + ')')
      .call(yearAxis)
  // Rotate x-axis labels
    .selectAll('text')
      .attr({
        y: 0,
        x: 9,
        dy: '.35em',
        transform: 'rotate(50)'
      })
      .style('text-anchor', 'start')
}
