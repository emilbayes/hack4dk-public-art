var d3 = require('d3')
var o = require('fn-compose').ltr
var ƒ = require('../d3-helpers/access-prop')

var offsetCenter = require('../d3-helpers/stack-offset-center')

module.exports = function (conv, data) {
  var yearScale = d3.scale.linear()
      .domain(d3.extent(data, ƒ('year')))
			.range(conv.x.range())

  var countScale = d3.scale.linear()
			.domain([0, 600])
			.range(conv.y.range())

  var area = d3.svg.area()
    .x(o(ƒ('x'), yearScale))
		.y0(o(ƒ('y0', 0), countScale))
		.y1(function (d) { return countScale(d.y0 + d.y) })

  var bin = d3.layout.histogram()
      .bins(d3.range.apply(d3, yearScale.domain()))
      .value(ƒ('year'))

  var stack = d3.layout.stack()
      .order('reverse')
      .offset(offsetCenter)
      .values(ƒ('values'))
      .x(ƒ('x'))
      .y(ƒ('y', 0))

  var genders = d3.nest()
      .key(ƒ('gender'))
      .rollup(bin)
      .entries(data
					.filter(ƒ('year'))
					.filter(function (d) { return d.gender !== 'grp' })
			)

  conv.svg.selectAll('path')
			.data(stack(genders))
		.enter().append('path')
			.attr('class', ƒ('key'))
			.attr('d', o(ƒ('values'), area))
			.style('fill', function (d) { return d.key === 'm' ? '#4E96A3' : '#FE664A' })
}
