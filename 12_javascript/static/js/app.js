// Assign the data from `data.js` to a descriptive variable
var tableData = data;

// Select the submit button
var submit = d3.select("#filter-btn");

//get a reference to the tbody
var tbody = d3.select("tbody");

//init function to be invoked on page load
function init() {
	data.forEach((sighting) => {
	  var row = tbody.append("tr");
	  Object.entries(sighting).forEach(([key, value]) => {
		var cell = tbody.append("td");
		cell.text(value);
	  });
	});
};

Date.prototype.valid = function() {
  return isFinite(this);
}
//invoke this submit function and filter the results
submit.on("click", function() {

  // Prevent the page from refreshing
  d3.event.preventDefault();

  // Select the input element and get the raw HTML node
  var inputElement = d3.select("#datetime");
  
  // Get the value property of the input element
  var inputValue = inputElement.property("value");
  
  // cast the input to a date object to check for a valid date
  var inputdate = new Date(inputValue);
  
  // invoke the filter if the input filter criteria has a value.
  if (!!inputValue) {
	//check for a valid date else return default list
	if (inputdate.valid()) {
		console.log(inputValue);
		var filteredData = tableData.filter(sighting => sighting.datetime === inputValue);
		// clear the existing output
		tbody.html("");
	
		filteredData.forEach((sighting) => {
			var row = tbody.append("tr");
			Object.entries(sighting).forEach(([key, value]) => {
				var cell = tbody.append("td");
				cell.text(value);
			});
		});
	}
	else{
		tbody.html("");
		init();}
	}
  else{
		tbody.html("");
		init();
  }
});

//invoke init on page load
init();
