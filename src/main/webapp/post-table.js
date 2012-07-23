function copyTableToFormField(tableId, fieldId) {
	var table = document.getElementById(tableId);
	var field = document.getElementById(fieldId);
	var divTmp = document.createElement('div');
	var tableTmp = document.createElement('table');
	divTmp.appendChild(tableTmp);
	tableTmp.innerHTML = table.innerHTML;
	field.value = divTmp.innerHTML;
	return false;
}