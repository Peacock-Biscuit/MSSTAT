// Global function called when select element is changed
function onCategoryChanged() {
    var select = d3.select('#categorySelect').node();
    // Get current value of select element
    var category = select.options[select.selectedIndex].value;
    // Update chart with the selected category of letters
    updateChart(category);
}

// recall that when data is loaded into memory, numbers are loaded as strings
// this function helps convert numbers into string during data preprocessing
function dataPreprocessor(row) {
    return {
        letter: row.letter,
        frequency: +row.frequency
    };
}

var svg = d3.select('svg');

// Get layout parameters
var svgWidth = +svg.attr('width');
var svgHeight = +svg.attr('height');

var padding = {t: 60, r: 40, b: 30, l: 40};

// Compute chart dimensions
var chartWidth = svgWidth - padding.l - padding.r;
var chartHeight = svgHeight - padding.t - padding.b;

// Compute the spacing for bar bands based on all 26 letters
var barBand = chartHeight / 26;
var barHeight = barBand * 0.7;

// Create a group element for appending chart elements
var chartG = svg.append('g')
    .attr('transform', 'translate('+[padding.l, padding.t]+')');

// A map with arrays for each category of letter sets
var lettersMap = {
    'all-letters': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
    'only-consonants': 'BCDFGHJKLMNPQRSTVWXZ'.split(''),
    'only-vowels': 'AEIOUY'.split('')
};

d3.csv('letter_freq.csv', dataPreprocessor).then(function(dataset) {
    // Create global variables here and intialize the chart
    letters = dataset;
    wScale = d3.scaleLinear()
                .domain([0, d3.max(dataset, function(d) {return d.frequency;})])
                .range([0, chartWidth])

    console.log(letters);
    // **** Your JavaScript code goes here ****
      
    // Define X axis
    var xAxisT = d3.axisTop()
                        .scale(wScale)
                        .ticks(7)
                        .tickFormat(function(d) {return d*100+"%";});

    var xAxisB = d3.axisBottom()
                        .scale(wScale)
                        .ticks(7)
                        .tickFormat(function(d) {return d*100+"%";});
    // Create X axis
    var bottom = chartHeight + padding.t
    var top = padding.t -5

    svg.append("g")
        .attr("class", "axis")
        .attr('transform', "translate("+padding.l+ ","+top+")")
        .call(xAxisT);

    svg.append("g")
        .attr("class", "axis")
        .attr('transform', "translate("+padding.l+ ","+bottom+")")
        .call(xAxisB);        

    var mid = svgWidth/2-50
    var topLetter = top-25
    svg.append('text')
            .attr('class', 'x label')
            .attr('transform', "translate("+mid+ ","+topLetter+")")
            .text('Letter Frequency (%)')
            .attr("fill", "black");
    // Update the chart for all letters to initialize
    updateChart('all-letters');
});


function updateChart(filterKey) {
    // Create a filtered array of letters based on the filterKey
    var filteredLetters = letters.filter(function(d){
        return lettersMap[filterKey].indexOf(d.letter) >= 0;
    });

    // **** Draw and Update your chart here ****
    console.log(filteredLetters);

    // var rects = chartG.selectAll("rect")
    //             .data(filteredLetters)
    //             .enter()
    //             .append("g")
    //             .append("rect")
    //             .attr("y", function(d, i) {
    //                 return i * barBand;
    //             })
    //             .attr("x", 20)
    //             .attr("height", barHeight)
    //             .attr("width", function(d) {
    //                 return wScale(d.frequency);
    //             })

    // var labels = chartG.selectAll("text")
    //                     .data(filteredLetters)
    //                     .enter()
    //                     .append("g")
    //                     .append("text")
    //                     .text(function(d) {
    //                         return d.letter;
    //                     })
    //                     .attr("y", function(d, i){
    //                         return i * barBand+12;
    //                     });
    // console.log(rects);

    var bars = chartG.selectAll(".bar")
                .data(filteredLetters, function(d) {
                    return d.letter;
                });
    var barsEnter = bars.enter()
                        .append("g")
                        .attr("class", "bar");
    bars.merge(barsEnter)
        .attr("transform", function(d, i){
            return "translate("+[0, i * barBand + 4] + ")";
        });
    barsEnter.append("rect")
            .attr("height", barHeight)
            .attr("width", function(d){
                return wScale(d.frequency);
            });
    barsEnter.append("text")
            .attr("x", -20)
            .attr("dy", "0.9em")
            .text(function(d) {
                return d.letter;
            });
    bars.exit().remove();
}

// Remember code outside of the data callback function will run before the data loads