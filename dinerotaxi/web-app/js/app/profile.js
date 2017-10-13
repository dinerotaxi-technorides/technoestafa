function saveChanges(setting,value){
	$.ajax({
    	type:'POST',
    	data:'setting='+setting + '&value='+value,
    	url:baseAppUrl + '/profile/saveSettings'
    });	
}
