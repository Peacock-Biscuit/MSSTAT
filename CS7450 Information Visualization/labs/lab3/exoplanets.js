
// **** Your JavaScript code goes here ****

d3.csv("exoplanets.csv").then(function(datum) {
	console.log(datum)
	var svg = d3.select("svg")

	// Create scale functions
	var hzdExtent = d3.extent(datum, function(d){
		return +d['habital_zone_distance'];
	});
	var massExtent = d3.extent(datum, function(d){
		return +d['mass'];
	});
	var colorExtent = d3.extent(datum, function(d){
		return +d['habital_zone_distance'];
	});

	var xScale = d3.scaleLinear()
					.domain(hzdExtent)
    				.range([100,500]);

	var yScale = d3.scaleLog()
				   .domain(massExtent)
				   .range([60,660]);	

	var radiusScale = d3.scaleSqrt()
						.domain([0, d3.max(datum, function(d) {return d.radius;})])
						.range([0, 20]);

	var colorScale = d3.scaleQuantize()
						.domain(colorExtent)
						.range(['#d64d3f', '#96ac3d', '#208d8d']);

	var formatAsPercentage = d3.format(".1%");
	// Define X axis
	var xAxis = d3.axisBottom()
						.scale(xScale)
						.ticks(10);

	// Define y axis
	var yAxis = d3.axisRight()
					  .scale(yScale)
					  .ticks(10);

	// Create circles
	svg.selectAll("circle")
		.data(datum)
		.enter()
		.append("circle")
		.attr("cx", function(d) {return xScale(d.habital_zone_distance);})
		.attr("cy", function(d) {return yScale(d.mass);})
		.attr("r", function(d) {return radiusScale(d.radius);})
		.attr("fill", function(d) {return colorScale(d.habital_zone_distance);})
		.style("opacity", 0.3)
		.attr("stroke", "white")
	// Create X axis
	svg.append("g")
		.attr("class", "axis")
		.attr('transform', 'translate(0,25)')
		.call(xAxis);

	// Create Y axis
	svg.append("g")
		.attr("class", "axis")
		.attr('transform', 'translate(35,0)')
		.call(yAxis);

	svg.append('text')
    		.attr('class', 'x label')
    		.attr('transform', 'translate(225,18)')
    		.attr("fill","white")
    		.text('Habital Zone Distance');

	svg.append('text')
    		.attr('class', 'y label')
    		.attr('transform', 'translate(25,450) rotate(270)')
    		.attr("fill","white")
    		.text('Planet Mass(relative to Earth)');
});
