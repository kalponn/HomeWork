
function createMap(geojson) {
  
  // Create the tile layer that will be the background of our map
  var lightmap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/256/{z}/{x}/{y}?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://mapbox.com\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.light",
    accessToken: API_KEY
    });
  
  // Create a baseMaps object to hold the lightmap layer
  var baseMaps = {
    "Light Map": lightmap
    };

  // Create an overlayMaps object to hold the earthquake layer
  var overlayMaps = {
    "EarthQuakes": geojson
  };

  // Create the map object with options
  var map = L.map("map", {
    center: [32.7767, -96.79],
    zoom: 5,
    layers: [lightmap, geojson]
  });

  // Create a layer control, pass in the baseMaps and overlayMaps. Add the layer control to the map
  L.control.layers(baseMaps, overlayMaps, {
    collapsed: false
  }).addTo(map);
}


function createMarkers(response) {
    var geojson;
	geojson = L.geoJSON(response, {
		valueProperty: "mag",
		scale: ["#ffffb2", "#b10026"],
		style: {
		  color: "#fff",
		  weight: 1,
		  fillOpacity: 0.8
		 },
		onEachFeature: function(feature, layer) {
		 layer.bindPopup("<h3><h3> Place:" + feature.properties.place + "<h3><h3>Magnitude: " + feature.properties.mag + "<h3><h3> Time: " + new Date(feature.properties.time) +"<h3>");
	 },
		pointToLayer: function (feature, latlng) {
			var geojsonMarkerOptions = {
				radius: 8 * feature.properties.mag,
				fillColor: "#ff7800",
				color: "#000",
				weight: 1,
				opacity: 1,
				fillOpacity: 0.8
			   };
			return L.circleMarker(latlng, geojsonMarkerOptions);
		}	
	});
  // Create a layer group made from the earthquake  markers array, pass it into the createMap function
	createMap(geojson);
}

// Store API query variables
var url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary//all_week.geojson";

// Grab the data with d3
d3.json(url, createMarkers);
