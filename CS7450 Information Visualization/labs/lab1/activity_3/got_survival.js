var main = d3.select('#main');

// Select all the house tabs
d3.selectAll('.got-tab')
    .on('click', function(){
        // On click, activate the selected tab (this), and de-select the previously active
        var clickedTab = d3.select(this);

        d3.select('.got-tab.active').classed('active',false);
        clickedTab.classed('active',true);

        // Get which house was selected, call updateBars
        var house = clickedTab.attr('data-house');
        updateBars(house);
    });

// Show bars for "top" house on page load
d3.select(window).on('load', function(){
    updateBars('top');
});

function renderBars(data) {
    // Create a selection for character survival bars
    var select = d3.selectAll('.got-survival')
        .data(data);

    // Append divs for each character, class them to reference later
    var enter = select.enter().append('div')
        .attr('class','got-survival');

    // Append a <p> element to the newly appended div.got-survival
    var pEnter = enter.append('p')
        .attr('class', 'got-person-name');

    // Append <div><div></div></div> to create the progress-bar structure
    var fillEnter = enter.append('div')
        .attr('class', 'got-progress-bar')
        .append('div')
        .attr('class', 'got-progress-bar-fill');

    // Append a <p> element to display the survival value
    var valEnter = fillEnter.append('p')
        .attr('class', 'got-progress-bar-value');

    // Now this is where we update both the newly created elements on screen and the ones already present

    // Merge the .got-person-name elements on screen elements with the newly created ones, and update name
    select.select('.got-person-name').merge(pEnter)
        .text(function(d){
            return d['name'];
        });

    // Merge the .got-progress-bar-fill on screen elements with the newly created ones, and update width
    select.select('.got-progress-bar-fill').merge(fillEnter)
        .style('width', function(d){
            return 'calc(' + d['probability_of_survival'] + '% - 3px)';
        });

    // Merge the .got-progress-bar-value on screen elements with the newly created ones, and update text,
    // positioning, and color
    select.select('.got-progress-bar-value').merge(valEnter)
        .text(function(d){
            return d['probability_of_survival'] + '%';
        })
        .style('padding-left',function(d){
            return d['probability_of_survival'] > 5 ? 0 : '30px';
        })
        .style('color',function(d){
            return d['probability_of_survival'] > 5 ? '#222' : '#fff';
        });

    // Remove all elements that no longer have data bound to them
    select.exit().remove();
}

// **** Your JavaScript code goes here ****

function updateBars(house) {
    // Edit this function to filter the characters based on affiliation
    // You will need a special case for the top characters 'top'
    var e = [];
    if (house == "top") {
        for (i=0; i<characters.length; i++) {
            if (characters[i].power_ranking != -1) {
                e.push(characters[i]);
            }
        }
    } else {
        for (i=0; i<characters.length; i++) {
            if (characters[i].house == house) {
                e.push(characters[i]);
            }
        }       
    }  
    e.sort(function(a, b) {
        return b.probability_of_survival - a.probability_of_survival;
    });
    renderBars(e);
}
