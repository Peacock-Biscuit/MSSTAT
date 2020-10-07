// Global functions called when select elements changed
function onXScaleChanged() {
    var select = d3.select('#xScaleSelect').node();
    // Get current value of select element, save to global chartScales
    chartScales.x = select.options[select.selectedIndex].value
    // Update chart
    updateChart();
}

function onYScaleChanged() {
    var select = d3.select('#yScaleSelect').node();
    // Get current value of select element, save to global chartScales
    chartScales.y = select.options[select.selectedIndex].value
    // Update chart
    updateChart();
}

// Load data and use this function to process each row
function dataPreprocessor(row) {
    return {
        'name': row['name'],
        'economy (mpg)': +row['economy (mpg)'],
        'cylinders': +row['cylinders'],
        'displacement (cc)': +row['displacement (cc)'],
        'power (hp)': +row['power (hp)'],
        'weight (lb)': +row['weight (lb)'],
        '0-60 mph (s)': +row['0-60 mph (s)'],
        'year': +row['year']
    };
}

var svg = d3.select('svg');

// Get layout parameters
var svgWidth = +svg.attr('width');
var svgHeight = +svg.attr('height');

var padding = {t: 40, r: 40, b: 40, l: 40};

// Compute chart dimensions
var chartWidth = svgWidth - padding.l - padding.r;
var chartHeight = svgHeight - padding.t - padding.b;

// Create a group element for appending chart elements
var chartG = svg.append('g')
    .attr('transform', 'translate('+[padding.l, padding.t]+')');

// Create groups for the x- and y-axes
var xAxisG = chartG.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate('+[0, chartHeight]+')');
var yAxisG = chartG.append('g')
    .attr('class', 'y axis');

d3.csv('cars.csv', dataPreprocessor).then(function(dataset) {
    // **** Your JavaScript code goes here ****
    cars = dataset;
    console.log(dataset);
    xScale = d3.scaleLinear()
    			.range([0, chartWidth]);
	yScale = d3.scaleLinear()
    			.range([chartHeight, 0]);
    domainMap = {};

	dataset.columns.forEach(function(column) {
    	domainMap[column] = d3.extent(dataset, function(data_element){
        	return data_element[column];
	    });
    });


    // Create global object called chartScales to keep state
    chartScales = {x: 'economy (mpg)', y: 'power (hp)'};
    updateChart();
});


function updateChart() {
    // **** Draw and Update your chart here ****

	// Update the scales based on new data attributes
	yScale.domain(domainMap[chartScales.y]).nice();
	xScale.domain(domainMap[chartScales.x]).nice();

	xAxisG.call(d3.axisBottom(xScale));
	yAxisG.call(d3.axisLeft(yScale));

	var dots = chartG.selectAll('.dot')
    					.data(cars);

    var dotsEnter = dots.enter()
					    .append('g')
					    .attr('class', 'dot')
					    .attr('transform', function(d) {
					        var tx = xScale(d[chartScales.x]);
					        var ty = yScale(d[chartScales.y]);
					        return 'translate('+[tx, ty]+')';
					    });
    
	dotsEnter.append('circle')
    			.attr('r', 3);

	dots.merge(dotsEnter)
    	.attr('transform', function(d) {
        	var tx = xScale(d[chartScales.x]);
        	var ty = yScale(d[chartScales.y]);
        	return 'translate('+[tx, ty]+')';
    });
    dotsEnter.append('text')
    	.attr('y', -10)
    	.text(function(d) {
        	return d.name;
    	});
	dots.merge(dotsEnter)
	    .transition()
	    .duration(750)
	    .attr('transform', function(d) {
	        var tx = xScale(d[chartScales.x]);
	        var ty = yScale(d[chartScales.y]);
	        return 'translate('+[tx, ty]+')';
	    });

	 xAxisG.transition()
    	.duration(750)
    	.call(d3.axisBottom(xScale));
	yAxisG.transition()
    	.duration(750)
    	.call(d3.axisLeft(yScale));
	    
}
// Remember code outside of the data callback function will run before the data loads