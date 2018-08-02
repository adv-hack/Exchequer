<!--
// BEGIN ROW CHANGE FUNCTIONS
var activeRow = null;

// Funstion to set the roll over color 
function rowOver(whichEl) {
	if ((!activeRow) || (activeRow && activeRow != whichEl)) whichEl.className = "row-over";
}

// Funstion to set the roll Out color 
function rowOut(whichEl) {
	if ((!activeRow) || (activeRow && activeRow != whichEl)) whichEl.className = "row";
}
//-->