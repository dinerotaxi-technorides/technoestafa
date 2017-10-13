function initWatchlists(watchid){
	if (watchid>-1){
		loadWatchlist(watchid);
	}
}

function createWatchlist (){
	$("#createWatchlist").click('').attr('onclick','');
	if($("#watchname").val()!=""){			
		var watchname=$("#watchname").val();
    	$.ajax({
	    	type:'POST',
	    	data:'name='+watchname,
	    	url:baseAppUrl + '/watch/createWatchlist',
	    	success:function(data,textStatus){
		    	$('#watchlistCombo').html(data);
		    	setVisibleWatchInfo(false);
		    	$('#watchlists option:last').attr('selected','selected');			    	
		    	$('#watchlists').change();
		    	$('#createWatchButton').show();
		    	$('#createWatchList').hide();
		    	$('#watchname').val('');
		    	$("#watchname").removeClass('invalid');
				showSuccessMessage("<p><strong>Your watchlist has been created.</strong> </p>");
		    },
		    error:function(data,textStatus){
		    	showErrorMessage("A problem occurred when creating the watchlist.</p>");
		    },
		    complete:function(){
		    	$("#createWatchlist").click('').attr('onclick','createWatchlist();');
		    }
		});			
	}else{
		$("#watchname").addClass('invalid');
	} 	    	
}

function deleteWatchlist(watchid){
	if(confirm("Do you really want to delete this watchlist?")){		
    	$.ajax({
	    	type:'POST',
	    	data:'watchid='+watchid, 
	    	url:baseAppUrl + '/watch/deleteWatchlist',
	    	success:function(data,textStatus){
	    		var comboElement = $(data);
		    	$('#watchlistCombo').html(comboElement);
		    	comboElement.bind('change', getWatchList());
		    	setVisibleWatchInfo(false);
			    $('#watchlists option:last').attr('selected','selected');
			    $('#watchlists').change();
		    }
	    });		    
	}
}

function changeWatchlist(watchid){
	if (watchid!=-1){
		loadWatchlist(watchid);
		$('#watchlist').change();
	}
}

function deleteTicker(symbol,watchid){
	$.ajax({
    	type:'POST',
    	data:'watchid='+watchid + '&symbol='+symbol, 
    	url:baseAppUrl + '/watch/deleteTicket',
    	success:function(data,textStatus){
	    	$('#tickets').html(data);
	    }
    });
}


function addTickets(id){
	var tickets=$('#autocompletejquery').val();
	if (tickets!=''){
		var watchid=id;
		$.ajax({
			type:'POST',
			data:'watchid='+watchid + '&symbol='+tickets, 
			url:baseAppUrl + '/watch/addTickets',
			beforeSend: function(){
				loading('watchlist');
			},
			success:function(data,textStatus){
				var comboElement = $(data);
				$('#tickets').html(comboElement);	    
			}
		});
	}else{
		$('#autocompletejquery').addClass('invalid');
	}
}

$('#autocompletejquery').click(function(){
	$('#autocompletejquery').removeClass('invalid');
});


function getWatchList(){
	var index = $('option:selected', '#watchlists').index();
	if(index!=0){
		var watchid = $('option:selected', '#watchlists').val()
    	loadWatchlist(watchid);
	}else{
		setVisibleWatchInfo(false);
    }
}

function loadWatchlist(id){
	var watchid=id;
	$.ajax({
    	type:'POST',
    	data:'watchid='+watchid, 
    	url:baseAppUrl + '/watch/getTickets',
    	beforeSend: function(){
	    	loading('tickets');
	    },
    	success:function(data, textStatus){
	    	$('#tickets').html(data);				    	
	    	setVisibleWatchInfo(true);
	    }
	});
}


function cancelCreate(){
	$("#createWatchButton").show();
	$('#createWatchList').hide();
	$("#watchname").val("");
	$("#watchname").removeClass("invalid");
}

function initWatchlistTextbox(){
	function split( val ) {
		return val.split(" ");
	}
	function extractLast( term ) {
		return split( term ).pop();
	}

	$( "#autocompletejquery" )
		// don't navigate away from the field on tab when selecting an item
		.bind( "keydown", function( event ) {
			if ( event.keyCode === $.ui.keyCode.TAB &&
					$( this ).data( "autocomplete" ).menu.active ) {
				event.preventDefault();
			}
		})
		.autocomplete({ 
			source: function( request, response ) {
				$.getJSON( "watch/autocompletewatchlist", {
					term: extractLast( request.term )
				}, response );
			},
			search: function() {
				// custom minLength
				var term = extractLast( this.value );
				if ( term.length < 1 ) {
					return false;
				}
			},
			focus: function() {
				// prevent value inserted on focus
				return false;
			},
			select: function( event, ui ) {
				var terms = split( this.value );
				// remove the current input
				terms.pop();
				// add the selected item
				terms.push( ui.item.value );
				// add placeholder to get the comma-and-space at the end
				terms.push( "" );
				this.value = terms.join( " " );
				return false;
			}
		});
}

function showQuoteMiniGraph(column){
	if (column==1){
		$('.day').show();
		$('.month').hide();
		$('.year').hide();
	}else if(column==2){
		$('.day').hide();
		$('.month').show();
		$('.year').hide();
	}else if(column==3){
		$('.day').hide();
		$('.month').hide();
		$('.year').show();
	}
}

function showChange(column){
	if (column==1){
		$('.dollar').show();
		$('.percent').hide();
	}else if(column==2){
		$('.dollar').hide();
		$('.percent').show();
	}
}

$('#autocompletejquery').keyup(function () { 
    this.value = this.value.replace(/[^a-zA-Z\.\s]/g,'');
});

