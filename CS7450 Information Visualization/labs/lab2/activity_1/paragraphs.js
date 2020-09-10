
// **** Your JavaScript code goes here ****
d3.csv('baseball_hr_leaders_2017.csv').then(function(dataset) {
	// the variable `dataset` is an array of data elements
	// d3.select("body")
	// 	.selectAll("p")
	// 	.data(dataset)
	// 	.enter()
	// 	.append("p")
	// 	.text(function(d, i) {return d.rank + ". " + d.name + " with " + d.homeruns + " home runs";})
	// 	.style('font-weight', function(d) {
	// 		return d.name == 'Giancarlo Stanton' ? 'bold' : 'normal';
	// 	})

	var group = d3.select("tbody")
					.selectAll("td")
					.data(dataset)
					.enter()
					.append("tr")


	group.append("td").text(function(d) {return d.rank;});
	group.append("td").text(function(d) {return d.name;});
	group.append("td").text(function(d) {return d.homeruns;});

});