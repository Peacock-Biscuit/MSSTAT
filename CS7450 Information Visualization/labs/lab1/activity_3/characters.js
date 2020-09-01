// Without a scope or var, this will be a global variable
characters = [
  {
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
  },
  {
    "name": "Catelyn Stark",
    "status": "Dead - Red Wedding S3E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 0
  },
  {
    "name": "Eddard Stark",
    "status": "Dead - Beheaded S1E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 0
  },
  {
    "name": "Rickon Stark",
    "status": "Dead - Arrows S6E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 0
  },
  {
    "name": "Dire Wolves",
    "status": "Mostly Alive",
    "current_location": "Winterfell / Unknown",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 60
  },
  {
    "name": "Davos Seaworth",
    "status": "Alive",
    "current_location": "Winterfell",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 78
  },
  {
    "name": "Theon Greyjoy (Reek)",
    "status": "Alive But Missing Appendages",
    "current_location": "Winterfell",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 74
  },
  {
    "name": "Benjen Stark",
    "status": "Alive(ish)",
    "current_location": "North Of The Wall",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 18
  },
  {
    "name": "Hodor",
    "status": "Dead - White Walkers S6E5",
    "current_location": "-",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 0
  },
  {
    "name": "Daenerys Targaryen",
    "status": "Alive",
    "current_location": "Way to Westeros",
    "power_ranking": 1,
    "house": "targaryen",
    "probability_of_survival": 99
  },
  {
    "name": "The Dragons",
    "status": "Alive",
    "current_location": "Way to Westeros",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 99
  },
  {
    "name": "Viserys Targaryen",
    "status": "Dead - Molten Gold S1E6",
    "current_location": "-",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 0
  },
  {
    "name": "Tyrion Lannister",
    "status": "Alive",
    "current_location": "Way to Westeros",
    "power_ranking": 4,
    "house": "targaryen",
    "probability_of_survival": 70
  },
  {
    "name": "Jon Snow",
    "status": "Alive... Again",
    "current_location": "Winterfell",
    "power_ranking": 3,
    "house": "stark",
    "probability_of_survival": 84
  },
  {
    "name": "Jorah Mormont",
    "status": "Alive (With Greyscale)",
    "current_location": "Trying To Find A Cure",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 33
  },
  {
    "name": "Grey Worm",
    "status": "Alive",
    "current_location": "Way To Westeros",
    "power_ranking": 9,
    "house": "targaryen",
    "probability_of_survival": 87
  },
  {
    "name": "Missandei",
    "status": "Alive",
    "current_location": "Way To Westeros",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 91
  },
  {
    "name": "Aemon Targaryen",
    "status": "Dead",
    "current_location": "-",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 0
  },
  {
    "name": "Barristan Selmy",
    "status": "Dead - Sons Of The Harpy S5E4",
    "current_location": "-",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 0
  },
  {
    "name": "Daario Naharis",
    "status": "Alive & Dreamy",
    "current_location": "Meereen",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 78
  },
  {
    "name": "Khal Drogo",
    "status": "Dead - Black Magic S1E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "targaryen",
    "probability_of_survival": 0
  },
  {
    "name": "Jaime Lannister",
    "status": "Alive",
    "current_location": "King's Landing",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 45
  },
  {
    "name": "Cersei Lannister",
    "status": "Alive",
    "current_location": "King's Landing",
    "power_ranking": 5,
    "house": "lannister",
    "probability_of_survival": 30
  },
  {
    "name": "Tywin Lannister",
    "status": "Dead - Arrows on Pot S4E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Joffery Baratheon",
    "status": "Dead - Poison S4E2",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Tommen Baratheon",
    "status": "Dead - Suicide S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Myrcella Baratheon",
    "status": "Dead - Poison S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Peter Balish (Little Finger)",
    "status": "Alive",
    "current_location": "Winterfell",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 23
  },
  {
    "name": "Bronn",
    "status": "Alive",
    "current_location": "King's Landing",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 74
  },
  {
    "name": "Shae",
    "status": "Dead - Strangulation S4E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Lancel Lannister",
    "status": "Dead",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  },
  {
    "name": "Sandor Clegane (The Hound)",
    "status": "Alive",
    "current_location": "Headed North",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 67
  },
  {
    "name": "Gregor Clegane (The Mountain)",
    "status": "Alive....(Frankenstein-ish)",
    "current_location": "King's Landing",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 48
  },
  {
    "name": "Qyburn",
    "status": "Alive / Not Even A Maester",
    "current_location": "King's Landing",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 35
  },
  {
    "name": "Grand Maester Pycell",
    "status": "Dead - Little Birds S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Robert Baratheon",
    "status": "Dead - Poison S1E7",
    "current_location": "-",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 0
  },
  {
    "name": "Stannis Baratheon",
    "status": "Dead - Sword S5E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 0
  },
  {
    "name": "Melisandre",
    "status": "Alive",
    "current_location": "Headed South From Winterfell",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 68
  },
  {
    "name": "Brienne Of Tarth",
    "status": "Alive & Oddly Tall",
    "current_location": "Fleeing Lannisters",
    "power_ranking": -1,
    "house": "stark",
    "probability_of_survival": 77
  },
  {
    "name": "Shireen Baratheon",
    "status": "Dead - Burned Alive S5E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 0
  },
  {
    "name": "Selyse Baratheon",
    "status": "Dead - Suicide S5E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 0
  },
  {
    "name": "Margaery Tyrell",
    "status": "Dead - Wildfire S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "tyrell",
    "probability_of_survival": 0
  },
  {
    "name": "Olenna Tyrell",
    "status": "Alive",
    "current_location": "The Reach or On Way To Westeros",
    "power_ranking": -1,
    "house": "tyrell",
    "probability_of_survival": 82
  },
  {
    "name": "Mace Tyrell",
    "status": "Dead - Wildfire S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "tyrell",
    "probability_of_survival": 0
  },
  {
    "name": "Loras Tyrell",
    "status": "Dead - Wildfire S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "tyrell",
    "probability_of_survival": 0
  },
  {
    "name": "Renly Baratheon",
    "status": "Dead - Blood Magic S2E5",
    "current_location": "-",
    "power_ranking": -1,
    "house": "baratheon",
    "probability_of_survival": 0
  },
  {
    "name": "The Night's King",
    "status": "Alive",
    "current_location": "Headed South",
    "power_ranking": 2,
    "house": "other",
    "probability_of_survival": 25
  },
  {
    "name": "Other White Walkers",
    "status": "Alive",
    "current_location": "Headed South",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 25
  },
  {
    "name": "Wights",
    "status": "Alive / Dead",
    "current_location": "Headed South",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 25
  },
  {
    "name": "Varys",
    "status": "Alive",
    "current_location": "Way To Westeros",
    "power_ranking": 6,
    "house": "targaryen",
    "probability_of_survival": 71
  },
  {
    "name": "Samwell Tarly",
    "status": "Alive",
    "current_location": "The Citadel",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 50
  },
  {
    "name": "Gilly",
    "status": "Alive",
    "current_location": "The Citadel",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 50
  },
  {
    "name": "Wun Wun",
    "status": "Dead - All the Arrows S6E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Oberyn Martell",
    "status": "Dead - Mountain Smash S4E8",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Ellaria Sand",
    "status": "Alive",
    "current_location": "On the Way to Westros",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 37
  },
  {
    "name": "Sand Sisters",
    "status": "Alive",
    "current_location": "On the Way to Westros",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 55
  },
  {
    "name": "High Sparrow",
    "status": "Dead - Dragon Fire S6E10",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Ramsay Bolton",
    "status": "Dead - Dog Food S6E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Roose Bolton",
    "status": "Dead - Bastard Stab S6E2",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Ygritte",
    "status": "Dead - Olly Arrow S4E9",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Mance Rayder",
    "status": "Dead - Courtesy Arrow S5E1",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Yara Greyjoy",
    "status": "Alive",
    "current_location": "On the Way to Westros",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 45
  },
  {
    "name": "Jaqen H'ghar",
    "status": "Alive",
    "current_location": "Everywhere & Nowhere",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 99
  },
  {
    "name": "Hot Pie",
    "status": "Alive",
    "current_location": "The Inn",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 31.4
  },
  {
    "name": "Lyza Arryn",
    "status": "Dead - Moon Door S4E7",
    "current_location": "-",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 0
  },
  {
    "name": "Robbin Arryn",
    "status": "Alive",
    "current_location": "The Vale",
    "power_ranking": -1,
    "house": "other",
    "probability_of_survival": 10
  },
  {
    "name": "The Frey's",
    "status": "Dead - Arya Revenge S6E2",
    "current_location": "-",
    "power_ranking": -1,
    "house": "lannister",
    "probability_of_survival": 0
  }
];
