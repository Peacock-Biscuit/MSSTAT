// DOM #main div element
var main = document.getElementById('main');

data = [{
	 "name": "Bran Stark",
	 "status": "Alive",
	 "current_location": "Fleeing White Walkers",
	 "power_ranking": 7,
	 "house": "stark",
	 "probability_of_survival": 98
},
{
	 "name": "Arya Stark",
	 "status": "Alive",
	 "current_location": "Back in Westeros",
	 "power_ranking": 8,
	 "house": "stark",
	 "probability_of_survival": 99
},
{
	 "name": "Sansa Stark",
	 "status": "Alive",
	 "current_location": "Winterfell",
	 "power_ranking": 10,
	 "house": "stark",
	 "probability_of_survival": 83
},
{
	 "name": "Robb Stark",
	 "status": "Dead - Red Wedding S3E9",
	 "current_location": "-",
	 "power_ranking": -1,
	 "house": "stark",
	 "probability_of_survival": 0
}]
// **** Your JavaScript code goes here ****
function halfSurvival(character) {
	return character.probability_of_survival / 2;
}
// favorite Arya stark
for (i = 0; i < data.length; i++) {
	char = data[i]
	if (char.name != "Arya Stark") {
		char.probability_of_survival = halfSurvival(char);
	}
}

function debugCharacters(data) {
	for (i = 0; i < data.length; i++) {
		character = data[i]
		console.log("Name "+ character.name + " probability_of_survival " + character.probability_of_survival);
	}
}

// document is the DOM, select the #main div
var main = document.getElementById("main");

// Create a new DOM element
var header = document.createElement("h3");
// Append the newly created <h3> element to #main
main.appendChild(header);
// Set the textContent to:
header.textContent = "My Favorite GoT Characters";

function createNew(i) {
	var div1 = document.createElement("div");
	main.appendChild(div1);
	var name = document.createElement("h5");
	div1.appendChild(name);
	name.textContent = "Name: " + data[i]["name"];
	var house = document.createElement("p");
	div1.appendChild(house);
	house.textContent = "House: " + data[i]["house"];
	// Create a new <p> element
	var survival= document.createElement("p");
	// Append the newly created <p> element to your new div
	div1.appendChild(survival);
	// Set the textContent to the first characters survival prob.
	survival.textContent = "Survival %: " +data[i]["probability_of_survival"] +"%";
	var status = document.createElement("p");
	div1.appendChild(status);
	status.textContent = "Status: " + data[i]["status"];
	return div1.innerHTML;
}

for (i=0; i < data.length; i++) {
	createNew(i);
}










