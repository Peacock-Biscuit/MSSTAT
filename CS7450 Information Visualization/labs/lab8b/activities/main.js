var map = d3.select('#map');
var mapWidth = +map.attr('width');
var mapHeight = +map.attr('height');

var atlLatLng = new L.LatLng(33.7771, -84.3900);
var myMap = L.map('map').setView(atlLatLng, 5);

var vertices = d3.map();
var activeMapType = 'nodes_links';
var nodeFeatures = [];

// L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//     attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
//     maxZoom: 10,
//     minZoom: 3,
//     id: 'mapbox.light',
//     accessToken: 'pk.eyJ1IjoiamFnb2R3aW4iLCJhIjoiY2lnOGQxaDhiMDZzMXZkbHYzZmN4ZzdsYiJ9.Uwh_L37P-qUoeC-MBSDteA'
// }).addTo(myMap); # color map

L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: '© <a href="https://www.mapbox.com/about/maps/">Mapbox</a> © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> <strong><a href="https://www.mapbox.com/map-feedback/"; target="_blank">Improve this map</a></strong>',
    maxZoom: 10,
    minZoom: 3,
    id: 'mapbox/light-v10',
    accessToken: 'sk.eyJ1IjoibXJpbGV5NyIsImEiOiJja2doZDRwcTgwYWxlMnpzMnhoOWZxbGVmIn0.0BTxT94_Ip9EdJir9z1Crg'
}).addTo(myMap);

var svgLayer = L.svg();
svgLayer.addTo(myMap)

var svg = d3.select('#map').select('svg');
var nodeLinkG = svg.select('g')
    .attr('class', 'leaflet-zoom-hide');

Promise.all([
    d3.csv('gridkit_north_america-highvoltage-vertices.csv', function(row) {
       var node = {v_id: +row['v_id'], LatLng: [+row['lat'], +row['lng']], type: row['type'],
           voltage: +row['voltage'], frequency: +row['frequency'], wkt_srid_4326: row['wkt_srid_4326']};
      vertices.set(node.v_id, node);
      node.linkCount = 0;
      nodeFeatures.push(turf.point([+row['lng'], +row['lat']], node));
       return node;
    }),
       d3.csv('gridkit_north_america-highvoltage-links.csv', function(row) {
       var link = {l_id: +row['l_id'], v_id_1: +row['v_id_1'], v_id_2: +row['v_id_2'],
           voltage: +row['voltage'], cables: +row['cables'], wires: +row['wires'],
           frequency: +row['frequency'], wkt_srid_4326: row['wkt_srid_4326']};
     	link.node1 = vertices.get(link.v_id_1);
		link.node2 = vertices.get(link.v_id_2);
		link.node1.linkCount += 1;
	    link.node2.linkCount += 1;
       return link;
    }),
       d3.json('states.json')
]).then(function(data) {
    var nodes = data[0];
    var links = data[1];
    var states = data[2];

    readyToDraw(nodes, links, states)
});

d3.selectAll('.btn-group > .btn.btn-secondary')
    .on('click', function() {
        var newMapType = d3.select(this).attr('data-type');

        d3.selectAll('.btn.btn-secondary.active').classed('active', false);

        cleanUpMap(activeMapType);
        showOnMap(newMapType);

        activeMapType = newMapType;
    });


function readyToDraw(nodes, links, states) {
	var nodeTypes = d3.map(nodes, function(d){return d.type;}).keys();
	var colorScale = d3.scaleOrdinal(d3.schemeCategory10).domain(nodeTypes);
    var linkCountExtent = d3.extent(nodes, function(d) {return d.linkCount;});
    var radiusScale = d3.scaleSqrt().range([0.5,7.5]).domain(linkCountExtent);

	var nodeCollection = turf.featureCollection(nodeFeatures);
	var chorostates = turf.collect(states, nodeCollection, 'v_id', 'values')
	statesLayer = L.geoJson(chorostates, {style: statesStyle});

	var bbox = turf.bbox(nodeCollection);
	var cellSize = 250;
	var options = {units: 'kilometers'};

	var triangleGrid = turf.triangleGrid(bbox, cellSize, options);
	var triangleBins = turf.collect(triangleGrid, nodeCollection, 'v_id', 'values');
	triangleBins.features = triangleBins.features.filter(function(d){
	   return d.properties.values.length > 0;
	});

	triangleExtent = d3.extent(triangleBins.features, function(d){
    	return d.properties.values.length;
	});
	var triangleScale = d3.scaleSequential(d3.interpolateMagma)
    						.domain(triangleExtent.reverse());

	var triangleStyle = function(f) {
	        return {
	            weight: 0.5,
	            opacity: 1,
	            color: 'white',
	            fillOpacity: 0.7,
	            fillColor: triangleScale(f.properties.values.length)
	        }
	    };

	triangleLayer = L.geoJson(triangleBins, {style: triangleStyle});

    nodeLinkG.selectAll('.grid-node')
        .data(nodes)
        .enter().append('circle')
        .attr('class', 'grid-node')
	    .style('fill', function(d){
        	return colorScale(d['type']);
        })
        .attr('r', function(d) {
            return radiusScale(d.linkCount);
        });

		myMap.on('zoomend', updateLayers);
   		updateLayers();
   	nodeLinkG.selectAll('.grid-link')
    	.data(links)
    	.enter().append('line')
    	.attr('class', 'grid-link')
    	.style('stroke', '#999')
    	.style('stroke-opacity', 0.5);

}

function updateLayers(){
   nodeLinkG.selectAll('.grid-node')
       .attr('cx', function(d){return myMap.latLngToLayerPoint(d.LatLng).x})
       .attr('cy', function(d){return myMap.latLngToLayerPoint(d.LatLng).y});

   nodeLinkG.selectAll('.grid-link')
       .attr('x1', function(d){return myMap.latLngToLayerPoint(d.node1.LatLng).x})
       .attr('y1', function(d){return myMap.latLngToLayerPoint(d.node1.LatLng).y})
       .attr('x2', function(d){return myMap.latLngToLayerPoint(d.node2.LatLng).x})
       .attr('y2', function(d){return myMap.latLngToLayerPoint(d.node2.LatLng).y});
};

function cleanUpMap(type) {
    switch(type) {
        case 'cleared':
            break;
        case 'nodes_links':
            nodeLinkG.attr('visibility', 'hidden');
            break;
        case 'states':
        	myMap.removeLayer(statesLayer);
        	break;
	    case 'triangle_bins':
        	myMap.removeLayer(triangleLayer);
        	break;
    }
}

function showOnMap(type) {
    switch(type) {
        case 'cleared':
            break;
        case 'nodes_links':
            nodeLinkG.attr('visibility', 'visible');
            break;
       case 'states':
           statesLayer.addTo(myMap);
           break;
       case 'triangle_bins':
           triangleLayer.addTo(myMap);
           break;

    }
}

var statesStyle = function(f) {
    return {
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7,
        fillColor: choroScale(f.properties.values.length)
    }
};

var choroScale = d3.scaleThreshold()
	.domain([10,20,50,100,200,500,1000])
	.range(d3.schemeYlOrRd[8]);




