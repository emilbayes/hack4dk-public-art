// var d3 = require('d3')
var c = require('d3-convention')({
  parent: window.document.querySelector('main')
})

// Hello World
c.svg.append('rect').style('fill', 'red').attr({
  x: c.x(0),
  y: c.x(0),
  width: c.x(1),
  height: c.x(1)
})
