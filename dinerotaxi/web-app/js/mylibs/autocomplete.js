/*
function alert(m) {
	document.getElementById('res').innerText=m; 
}
*/

options = { 
	preMsgTxt: "Search Stock Symbol", // text to display when nothing has been typed 
	menuOpacity: 94, // opacity of the menu 
	//ajaxUrl: "http://www.tradefields.com/facebook/autocomplete_answer.php", // url to your data source, must be absolute URL 
	focus: false, // whether or not to auto-focus the textbox upon creation 
	delayTime: 200, // amount of idle time after a keypress before making the ajax call 
	clearOnEnter: true // whether or not to clear the text after they hit enter 
}; 

function ajaxSuggestFbml(obj, options, url) {
	this.obj = obj;
	// Parent Div
	this.superNode = document.createElement('div');
	this.superNode.className='suggest_box_parent';
	//this.obj.parentNode.appendChild(this.superNode);
	$(this.obj).parent().append($(this.superNode));
	//this.superNode.appendChild(this.obj);
	$(this.superNode).append($(this.obj));
	this.parentDiv = document.createElement('div');
	this.parentDiv.className='suggest_box';
	//this.superNode.appendChild(this.parentDiv); 
	$(this.superNode).append($(this.parentDiv));
	this.url = url == null ? "" : url;
	
	// Loading message
	this.message =  document.createElement('div');
	this.message.style.display = 'none';
	//this.parentDiv.appendChild(this.message);
	$(this.parentDiv).append($(this.message));

	// Setup the events we're listening to
	
	$(this.obj).focus(this.onfocus.bind(this));
	$(this.obj).blur(this.onblur.bind(this));
	$(this.obj).keyup(this.onkeyup.bind(this));
	$(this.obj).keydown(this.onkeydown.bind(this));
	$(this.obj).keypress(this.onkeypress.bind(this));
	
	/*
	this.obj.addEventListener('focus', this.onfocus.bind(this));
	this.obj.addEventListener('blur', this.onblur.bind(this))
	this.obj.addEventListener('keyup', this.onkeyup.bind(this))
	this.obj.addEventListener('keydown', this.onkeydown.bind(this))
	this.obj.addEventListener('keypress', this.onkeypress.bind(this));
	*/
	 
	/*$.proxy(this,this.onfocus);
	$.proxy(this,this.onblur);
	$.proxy(this,this.onkeyup);
	$.proxy(this,this.onkeydown);
	$.proxy(this,this.onkeypress);
	*/
	/*
	$(this.obj).focus($.proxy(this,"onfocus"));
	$(this.obj).blur($.proxy(this,"onblur"));
	$(this.obj).keyup($.proxy(this,"onkeyup"))
	$(this.obj).keydown($.proxy(this,"onkeydown"))
	$(this.obj).keypress($.proxy(this,"onkeypress"));
	*/
	// Create the dropdown list that contains our suggestions
	this.list = document.createElement('div');
	this.list.className='suggest_list';
	this.list.style.display = 'none';
	//this.parentDiv.appendChild(this.list);
	$(this.parentDiv).append($(this.list));

	// Various flags
	this.focused = true;
	this.options = options == null ? {} : options;
	this.selectedindex = -1;
	this.delayTime = options.delayTime == null ? 700 : options.delayTime;
	this.preMsgTxt = options.preMsgTxt == null ? "Search Stock Symbol" : options.preMsgTxt;
	this.normOpac = options.menuOpacity == null ? 94 : options.menuOpacity;
	this.curOpac = this.normOpac;

	this.cache = {};
	this.obj.style.margin = "0px";

	if(!options.focus) {
		this.preMsg = true;
		this.obj.value=this.preMsgTxt;
		this.obj.className= "suggest_pretext";
	} else {
		//this.obj.focus();
		this.preMsg = false;
		this.update_results();
	}
};

// Show suggestions when the user focuses the text field
ajaxSuggestFbml.prototype.onfocus = function(event) {
	this.show();
	if(this.preMsg) {
		this.obj.value="";
		$(this.obj).removeClass("suggest_pretext");
		this.preMsg = false;
	}
	this.focused = true;
	this.update_results();
	$(this.obj).removeClass('suggest_found');
};

// ...and hide it when they leave the text field
ajaxSuggestFbml.prototype.onblur = function() {
	if(this.obj.value == "") {
		this.preMsg = true;
		this.obj.value=this.preMsgTxt;
		$(this.obj).removeClass("suggest_pretext");
	}
	this.focused = false;
	this.hide();
};

// Every keypress updates the suggestions
ajaxSuggestFbml.prototype.onkeyup = function(event) {
	switch (event.keyCode) {
		case 27: // escape
			this.hide();
			$(this.obj).removeClass('suggest_found');
			break;
		case 13: // enter
			if(this.options!=null && this.options.onEnter!=null) {
				this.hide();
				this.options.onEnter(event);
				
				if(this.options.clearOnEnter == true) {
					this.obj.value = '';
					this.hide();
					$(this.obj).removeClass('suggest_found');
				}
			}
			break;
		case 0:  
		case 37: // left
		case 9:  // tab
		case 38: // up
		case 39: // right
		case 40: // down
			break;
		default:
			this.selectedindex = -1;
			this.update_results();
			$(this.obj).removeClass('suggest_found');
			break;
	}
};

// We want interactive stuff to happen on keydown to make it feel snappy
ajaxSuggestFbml.prototype.onkeydown = function(event) {
	switch (event.keyCode) {
		case 9: // tab
		case 13: // enter
			if (this.Result[this.selectedindex]) {
				$(this.obj).addClass('suggest_found');
				this.obj.value = this.Result[this.selectedindex].symbol;
				this.hide();
				event.preventDefault();
			}
			break;

		case 38: // up
			this.select(this.selectedindex - 1);
			event.preventDefault();
			break;

		case 40: // down
			this.select(this.selectedindex + 1);
			event.preventDefault();
			break;
	}
};

// Override these events so they don't actually do anything
ajaxSuggestFbml.prototype.onkeypress = function(event) {
	switch (event.keyCode) {
	    case 13: // return
		case 9:  // tab
		case 38: // up
		case 40: // down
      		event.preventDefault();
      		break;
	}
};

// Select a given index
ajaxSuggestFbml.prototype.select = function(index) {
	var children = this.list.childNodes;
	
	if(children != null && children.length > 0) {
		if(index<0)
			index = 0;
		if(index >= children.length)
			index = children.length - 1;
		
		if(this.selectedindex >=0 && this.selectedindex < children.length )
			$(children[this.selectedindex]).removeClass('suggest_selected');
		$(children[(this.selectedindex=index)]).addClass('suggest_selected');
	}
};

ajaxSuggestFbml.prototype.startLoading = function(text) {
	
	this.message.className= text==""?"suggest_message":"suggest_loading_message";
	this.message.style.display = 'block';
	
	if(text != "" && text!= "Search Stock Symbol") {
		this.message.innerHTML = 'Loading suggestions for: ';
		var em = document.createElement('em');
		em.innerHTML = text;
		//this.message.appendChild(em);
		$(this.message).append(em);
	}
	else
		this.message.innerHTML = 'Type something to look for a stock symbol';
		
};

ajaxSuggestFbml.prototype.finishLoading = function(gotValues, text) {

	if(gotValues)
		this.message.style.display='none';
	else{
		this.message.innerHTML = 'No matches for ';
		var em = document.createElement('em');
		em.innerHTML = text;
		//this.message.appendChild(em);
		$(this.message).append(em);
		this.message.className = "suggest_loading_error";
	}
	
};

ajaxSuggestFbml.prototype.transformSymbol = function(symbol) {
	if(symbol[0] == '^')
		return null;
	if(symbol.indexOf(".")<0)
		return symbol.replace("-",".");
		
	symbolSplitted = symbol.split('.');
	if(symbolSplitted[1]=="OB" || symbolSplitted[1]=="PK")
		return symbolSplitted[0];
		
	return null;	
};

ajaxSuggestFbml.prototype.transformResult = function(string) {
	var pattern = /\{"symbol":"[^"]*",[^\}]*\}/gi;
	
	symbolMatches = string.match(pattern);
	var resultSet = [];
	if(symbolMatches != null) {
		for(var s=0; s<symbolMatches.length; s++) {
			var result = {};
			matches = symbolMatches[s].split('"');
			result.symbol = this.transformSymbol(matches[3]);		
			result.name = matches[7];		
			result.exch = matches[11];		
			result.type = matches[15];	
			result.exchDisp = matches[19];
			if(result.symbol != null)
				resultSet.push(result);	
		}
	}
	var data = {};
	match = string.match(/Query":"([^"]*)/g);
	data.Query = match != null ? match[0].split('"')[2] : "";
	data.Result = resultSet;
	return data;
};

ajaxSuggestFbml.prototype.onajaxdone = function(data) {
//	data = this.transformResult(data);
	this.finishLoading(data.Result.length>0, data.Query);
	
	// save to the cache
	this.cache[data.Query].Result = data.Result;
	this.cache[data.Query].curRequest = null;
	
	// if its valid, update the UI
	if(this.get_norm_typed() == data.Query) {
		this.draw_results(data.Result, data.Query);
		this.Result = data.Result;
	}
};


//ajaxSuggestFbml.prototype.onajaxdone = function(data) {
//	data = this.transformResult(data);
//	this.finishLoading(data.Result.length>0, data.Query);
//	
//	// save to the cache
//	this.cache[data.Query].Result = data.Result;
//	this.cache[data.Query].curRequest = null;
//	
//	// if its valid, update the UI
//	if(this.get_norm_typed() == data.Query) {
//		this.draw_results(data.Result, data.Query);
//		this.Result = data.Result;
//	}
//};


ajaxSuggestFbml.prototype.get_norm_typed = function() {
	return this.obj.value.toLowerCase();
};

ajaxSuggestFbml.prototype.getValue = function() {
	return (this.preMsg?"":this.obj.value);
};


ajaxSuggestFbml.prototype.get_suggest_item = function(typed, string, className, useHighlight) {
	var div = document.createElement('div');
	div.className = "suggest_"+className;
	$(div).addClass("suggest_field");
	var item = div;
	
	if(!useHighlight) {
		item.innerHTML = string;
		return item;
	}
		
	var begins = string.toLowerCase().indexOf(typed);
	if (begins == -1) {
		var span = document.createElement('span');
		span.innerHTML = string;
		var span_item = span;
		//item.appendChild(span_item);
		$(item).append(span_item);
	} else {
		if (begins > 0) {
			var span = document.createElement('span');
			span.innerHTML = string.substring(0, begins);
			//item.appendChild(span);
			$(item).append(span);
		}
		var em = document.createElement('em');
		em.innerHTML = string.substring(begins, begins + typed.length);
		var em_item = em;
		//item.appendChild(em_item);
		$(item).append(em_item);
		
		var span = document.createElement('span');
		span.innerHTML = string.substring(begins + typed.length);
		
		var span_item = span;
		//item.appendChild(span_item);
		$(item).append(span_item);
	}
	
	return item;
};


ajaxSuggestFbml.prototype.draw_results = function(Result, typed) {
	this.list.innerHTML = '';
	if(Result == null || Result.length == 0){
		this.list.style.display = 'none';
		return;
	}
	this.list.style.display = '';
	for( var i = 0; i < Result.length; i++ ) {
		var item = document.createElement('div');
		item.className = 'suggest_suggestion';

		
		//$(this.item).focus($.proxy(this,"onfocus"));
		
		$(item).mouseover(function() {
				this[0].select(this[1]); 
			}.bind([this, i]));
		
		$(item).mousedown(function(event) {
				$(this.obj).addClass('suggest_found');
					this.obj.value = this.Result[this.selectedindex].symbol;
				this.hide();  
			}.bind(this));
		
		/*
		item.addEventListener('mouseover', 
					function() {
						this[0].select(this[1]); 
					}.bind([this, i]));
		item.addEventListener('mousedown', 
					function(event) {
						$(this.obj).addClass('suggest_found');
	 					this.obj.value = this.Result[this.selectedindex].symbol;
						this.hide();  
					}.bind(this));
		*/
		
		//item.appendChild(this.get_suggest_item(typed, Result[i].symbol, "symbol", true));
		//item.appendChild(this.get_suggest_item(typed, Result[i].name, "name", true));
		//item.appendChild(this.get_suggest_item(typed, Result[i].exchDisp, "exchange", false));
		//this.list.appendChild(item);
		
		/*
		 $(item).append(this.get_suggest_item(typed, Result[i].symbol, "symbol", true));
		$(item).append(this.get_suggest_item(typed, Result[i].name, "name", true));
		
		$(item).append(this.get_suggest_item(typed, Result[i].exchDisp, "exchange", false));
		
		$(this.list).append(item); 
		 */
		
		var container1 = document.createElement('div');
		var container2 = document.createElement('div');
		
		$(container1).append(this.get_suggest_item(typed, Result[i].symbol, "symbol", true));
		$(container1).append("<br/>");
		
		var exchange_class = (Result[i].exchDisp.length>8)?"exchange_sm":"exchange";
		$(container1).append(this.get_suggest_item(typed, Result[i].exchDisp, exchange_class, false));
		
		$(container1).addClass("suggestion-block-a");
		$(container2).addClass("suggestion-block-b");	
		
		$(container2).append(this.get_suggest_item(typed, Result[i].name, "name", true));
		
		$(item).append(container1);
		$(item).append(container2);
		$(this.list).append(item);
		
	}
};

ajaxSuggestFbml.prototype.send_ajrequest = function(val) {
	// ajax query
	var request = {};
	var context = this;
	request.post = function() {
		$.ajax({
			url: context.url+"/common/search?val="+val, 
			dataType: 'json',
			success: function(objs){
				context.onajaxdone(objs);
			}
		});
	};
	/*
	request.requireLogin = false;
	request.responseType = Ajax.JSON;
	request.onerror = function() { };
	request.ondone = this.onajaxdone.bind(this);
	*/
	
//	
	
	
	this.cache[val] = {curRequest: request};
	//this.cache[val].curRequest.post("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="+val+"&callback=YAHOO.Finance.SymbolSuggest.ssCallback", {suggest_typed: val});
	this.cache[val].curRequest.post();
};

// This is called every keypress to update the suggestions
ajaxSuggestFbml.prototype.update_results = function() {
	// Search the list of potential results and find ones that match what we have so far
	var val = this.get_norm_typed();
	
	this.message.style.display = 'none';
	
	if(this.cache[val] != null) {
		// pull from el cache
		this.draw_results(this.cache[val].Result,val);
		this.Result = this.cache[val].Result;
		
	} else if(this.cache[val] == null || this.cache[val].curRequest == null){
		if(this.requestTimer != null)
			clearTimeout(this.requestTimer);
		this.requestTimer = setTimeout(
			function() { 
				this.startLoading(val);
				if(val != '')
					this.send_ajrequest(val); 
				else
					this.list.innerHTML = '';
				this.requestTimer = null;
			}.bind(this), this.delayTime);
		/*
		this.requestTimer = setTimeout($.proxy(
				function() { 
					this.startLoading(val);
					if(val != '')
						this.send_ajrequest(val); 
					else
						this.list.innerText = '';
					this.requestTimer = null;
				},this), this.delayTime);
		*/
	}
};

ajaxSuggestFbml.prototype.cleanup = function() {
	this.hide();
	this.obj.value = '';
	$(this.obj).removeClass('suggest_found');
}

ajaxSuggestFbml.prototype.show = function() {
	this.parentDiv.style.display = '';
};

ajaxSuggestFbml.prototype.hide = function() {
	this.selectedindex = -1;
	this.parentDiv.style.display = 'none';
	this.message.style.display = 'none';
};
/*
function bind (){
	var a=Array.prototype.slice.call(arguments),c=a.shift(),b=a.shift();
	var d=function(){
		//++FB.Monitor.internalCallStackDepth;
		var e=c.apply(b,a.concat(Array.prototype.slice.call(arguments)));
		//--FB.Monitor.internalCallStackDepth;return e;
	};
	d._targets=[b,c];
	return d;
}
Object.prototype.bind = bind;
*/
Function.prototype.bind = function(scope) {
	  var _function = this;
	  
	  return function() {
	    return _function.apply(scope, arguments);
	  }
	}

