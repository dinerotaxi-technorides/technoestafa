function $_(el) {
	return typeof el == "string" ? document.getElementById(el) : el;
}

function setInnerXHTML(id, html) {	
	var el = $_(id);	
	if (el.setInnerXHTML) {
		el.setInnerXHTML(html);
	} else {
		el.innerHTML = html;
	} 
}

function setClass(id, theClass) {
	var el = $_(id);
	if (el.setClassName) {
		el.setClassName(theClass);
	} else {
		el.className = theClass;
	}
}



function getDate(year, month, day, hours, minutes, seconds) {
	date = new Date();
	date.setFullYear(year);
	date.setMonth(month-1); 
	date.setDate(day);

	if(hours) {
		date.setHours(hours);
		date.setMinutes(minutes);
		date.setSeconds(seconds);
	}
	return date;
}




/* FACEBOOK WRAPPERS */



function padTo2(n) {
	return n < 10 ? "0" + n : n;
}



/*****************************************************************************************************/
/******************************************* Market Countdown ****************************************/
/*****************************************************************************************************/





var clockDigit = function(number, fps) {
	if (!fps) { fps = 30};
	this.interval = 1000 / fps
	this.number = parseInt(number);
	this.element = document.createElement('div');
	setClass(this.element,'clockDigit');
	var self = this;
	this.timer = setTimeout(function() {self.width = 19;self.height = 30;self.display(false, false);},this.interval);
	return this;
}

clockDigit.prototype.display = function(phase, callback) {
	if (!phase) {
		phase = 0;
	}
	num = this.number==0? 9:this.number-1;
	shift = (((num*6)+parseInt(phase+3))*38)%2318;
	this.element.style.backgroundPosition = '0px -' + shift +'px';
	phase++;
	if ((phase != 3) && (phase != 6)) {
		var self = this;
		this.timer = setTimeout(function() {self.display(phase,callback);},self.interval);
	} else {
		if(callback) {
			this.timer = setTimeout(this.callback,this.interval);
		}
	}
}
clockDigit.prototype.changeNumber = function(number) {
	var self = this;
	this.callback = function() {
		self.number = number;
		self.display(false);
	}
	this.display(3, true);
}
clockDigit.prototype.destroy = function () {
	this.element.parentNode.removeChild(this.element);
	//delete(this);
	
}

function marketCountdown(id) {
	this.market_holidays = [
		[new getDate(2010,7,5), "Independence Day"],
		[new getDate(2010,9,6), "Labor Day"],
		[new getDate(2010,11,25), "Thanksgiving Day"],
		[new getDate(2010,12,24), "Christmas Day"],
		[new getDate(2011,1,17), "Martin Luther King, Jr. Day"],
		[new getDate(2011,2,21), "Presidents' Day"],
		[new getDate(2011,4,22), "Good Friday"],
		[new getDate(2011,5,30), "Memorial Day"],
		[new getDate(2011,7,4), "Independence Day"],
		[new getDate(2011,9,5), "Labor Day"],
		[new getDate(2011,11,24), "Thanksgiving Day"],
		[new getDate(2011,12,26), "Christmas Day"]
	];
	
	this.market_early_close = [
		[new getDate(2010,11,26), "Day after Thanksgiving"],
		[new getDate(2011,11,25), "Day after Thanksgiving"]
	];
	this.clockDigits = [];
	
	this.setUpDates();
	this.wasOpen = !this.isOpen();
	this.parentId = id;
	this.testDate = null;
	
	var modificationFunction = function() {
		this.updateNow();
		var open = this.isOpen();
		if(this.wasOpen != open)
			this.setUpDates();		
			
		if(open){
			this.seconds = Math.abs((this.now.getTime()-this.closeTime)/1000);
		}
		else{
            time = this.now.getTime();
            this.seconds = (this.openTime-time)/1000;
            if(this.isHoliday) {
                this.seconds += 60*60*24;
            }
            if(this.isHoliday || time%(24*3600000) > this.openTime%(24*3600000)) {
                this.seconds +=this.holidaysAhead*60*60*24;
            }
            this.seconds = Math.abs(this.seconds);
		}
		
		if($_(this.parentId).firstChild == null || (($_(this.parentId).firstChild != null) && $_(this.parentId).firstChild.nodeType == 3)) {
		
			setInnerXHTML(this.parentId,"<div>"+"<div id='market_status' class='text'></div><div id=\"timer\"></div></div>");
			this.createTimer($_(this.parentId).firstChild.childNodes[1]);
		}
		this.updateTimer();

//		setInnerXHTML($_(this.parentId).firstChild.firstChild, "<div><span>Markets " +((open ? "<span class=\"markets-open\">Open</span> for </span>" : "<span class=\"markets-closed\">Closed</span>. Will open in </span>")+"<div class='holiday'>" + (this.earlyClose == "" ? this.holiday : this.earlyClose) + "</div></div>" ) );
		setInnerXHTML($_(this.parentId).firstChild.firstChild, "<div class='holiday'>" + (this.earlyClose == "" ? this.holiday : this.earlyClose) + "</div><div><span>Markets " +((open ? "<span class=\"markets-open\">Open</span> for </span>" : "<span class=\"markets-closed\">Closed</span>. Will open in </span>")+"</div>" ) );
		
	};
	modificationFunction.bind(this)();	
	this.interval = setInterval(modificationFunction.bind(this), 1000);

}; 


marketCountdown.prototype = {
	
	timeToNumberArray: function(time) {

		var secondsArray = [86400, 3600, 60, 1];
		var digits = [];
		var currentPart;
		for (var index=0; index < secondsArray.length; index++) {
			if (time < secondsArray[index]) {
				currentPart = 0;
			} else {
				currentPart = Math.floor(time / secondsArray[index]);
				time -= currentPart * secondsArray[index];
			}
			var digitString = ""+ currentPart;

			if(currentPart < 10) {
				digits.push('0');
				digits.push(digitString);
			}  else {
				digits.push(digitString.charAt(0));
				digits.push(digitString.charAt(1));			
			}
		}		
		return digits;
	},

	updateTimer: function() {
		this.seconds -= 1;		
		if (this.seconds == 0) {
			rp_destroyMarketIndicator()
		} else {			
			var clockDigitArray = this.timeToNumberArray(this.seconds);			
			for (var index = 0; index < clockDigitArray.length; index++) {
				currentNumber = clockDigitArray[index];				
				if(this.clockDigits[index].number != currentNumber) {
					this.clockDigits[index].changeNumber(currentNumber);
				}
			}
		}
	},

	createTimer: function(element) {
		var numberString = [0, 0, 0, 0, 0, 0, 0, 0];
		for (var index = 0; index < numberString.length; index++) {
			currentNumber = numberString[index];
			currentElement = new clockDigit(currentNumber);
			this.clockDigits[index] = currentElement;
			if(index%2==0 && index!=0){
				colons = document.createElement('div');
				setClass(colons,'clockDigitColons');
				element.appendChild(colons);
			}
			element.appendChild(currentElement.element);
		}
	},
	

	setUpDates: function()
	{
		//this.dlsOn = this.isInDLS();
		this.dlsOn = true;
		this.updateNow();

		//Old Markets Closed
//		this.marketsClosed = new this.utcDate(this.now.getUTCFullYear(), this.now.getUTCMonth(), this.now.getUTCDate(), this.isEarlyClose(this.now)?13:16, 0);
		//New Markets Closed
		this.marketsClosed = new this.utcDate(this.now.getUTCFullYear(), this.now.getUTCMonth(), this.now.getUTCDate(), this.isEarlyClose(this.now)?11:14, this.isEarlyClose(this.now)?0:30);
		this.closeTime = this.marketsClosed.getTime();
	
		openDay = this.closeTime > this.now.getTime() ? this.now : this.tomorrow(this.now);
		//Old Markets Open
//		this.marketsOpen = new this.utcDate(openDay.getUTCFullYear(), openDay.getUTCMonth(), openDay.getUTCDate(), 9, 30);
		//New Markets Open
		this.marketsOpen = new this.utcDate(openDay.getUTCFullYear(), openDay.getUTCMonth(), openDay.getUTCDate(), 8, 30);
		this.openTime = this.marketsOpen.getTime();

		this.holiday = this.getHoliday(this.now);
		this.isHoliday = this.getHolidaysAhead(this.now)>0;
		this.holidaysAhead = this.getHolidaysAhead(this.tomorrow(this.now));
		this.wasOpen = this.isOpen();
	},

	isOpen: function()
	{
		return !this.isHoliday && this.openTime < this.now.getTime() && this.now.getTime() < this.closeTime;
	},

	utcDate: function(year,month,day,hours,minutes)
	{
		date = new Date();
		date.setUTCFullYear(year);
		date.setUTCMonth(month);
		date.setUTCDate(day);
		date.setUTCHours(hours);
		date.setUTCMinutes(minutes);
		date.setUTCSeconds(0);
		//date.setTime(date.getTime()+((this.dlsOn?5:4)*3600000));
		date.setTime(date.getTime()+(5*3600000));
		return date;
	},

	tomorrow: function(day)
	{
		date = new Date();
		date.setTime(day.getTime() + 60*60*24*1000);
		return date;
	},

	isEarlyClose: function(day)
	{
		for(i=0; i<this.market_early_close.length; i++) 
			if(day.getUTCDate()==this.market_early_close[i][0].getUTCDate() && day.getUTCMonth()==this.market_early_close[i][0].getUTCMonth() && 	day.getUTCFullYear()==this.market_early_close[i][0].getUTCFullYear()) {
				this.earlyClose = this.market_early_close[i][1] + " (early close)";
				return true;
			}
			
		this.earlyClose = "";
		return false;
	},
	
	getHoliday: function(day)
	{
		for(i=0; i<this.market_holidays.length; i++) {
			if(day.getUTCDate()==this.market_holidays[i][0].getUTCDate() && day.getUTCMonth()==this.market_holidays[i][0].getUTCMonth() && day.getUTCFullYear()==this.market_holidays[i][0].getUTCFullYear()) {
				return this.market_holidays[i][1];
			}
		}
		return "";
	},

	getHolidaysAhead: function(day)
	{
		if(day.getUTCDay()==0 || day.getUTCDay()==6) {// Sunday or Saturday
			return 1 + this.getHolidaysAhead(this.tomorrow(day));
		}

		else {
			if((this.getHoliday(day)) != "")
				return 1 + this.getHolidaysAhead(this.tomorrow(day));
		}

		return 0;
	},
	
	test: function(year, month, day, hours, minutes, seconds) 
	{
		this.testBase = new Date();
		this.testDate = new getDate(year, month, day, hours, minutes, seconds);
		this.setUpDates();
	//	this.debug(this.testDate.getTime());
	},
	
	stop: function() 
	{
		clearInterval(this.interval);
	},

	updateNow: function()
	{
		if(this.testDate == null){
			this.now = new Date();
		}
		else {
			now = new Date();
			this.now.setTime(this.testDate.getTime() + (now.getTime() - this.testBase.getTime()) );
		}
	},

	isInDLS: function()
	{
		var now = new Date();

		var dst_start = new Date();
		var dst_end = new Date();
		// Set dst start to 2AM 2nd Sunday of March
		dst_start.setMonth( 2 ); // March
		dst_start.setDate( 1 ); // 1st
		dst_start.setHours( 2 );
		dst_start.setMinutes( 0 );
		dst_start.setSeconds( 0 ); // 2AM

		// Need to be on first Sunday

		if( dst_start.getDay() )
		   dst_start.setDate( dst_start.getDate() + ( 7 - dst_start.getDay() ) );

		// Set to second Sunday

		dst_start.setDate( dst_start.getDate() + 7 );    
		// Set dst end to 2AM 1st Sunday of November

		dst_end.setMonth( 10 );
		dst_end.setDate( 1 );
		dst_end.setHours( 2 );
		dst_end.setMinutes( 0 );
		dst_end.setSeconds( 0 ); // 2AM

		// Need to be on first Sunday

		if( dst_end.getDay() )
		   dst_end.setDate( dst_end.getDate() + ( 7 - dst_end.getDay() ) );

		return ( now > dst_start && now < dst_end );
	},
	
	hhMmSs: function(ms) 
	{
		var s = Math.round(ms / 1000);
		return (s < 86400 ? "" : "<span class='days'>"+ Math.floor(s / 86400) + "</span><span class='colon'>:</span>") + "<span class='hours'>" +
			padTo2(Math.floor(s % 86400 / 3600)) + "</span><span class='colon'>:</span><span class='minutes'>" +
			padTo2(Math.floor(s % 3600 / 60)) + "</span><span class='colon'>:</span><span class='seconds'>" +
			padTo2(s % 60) + "</span>";
	},

	debug: function(text)
	{
		if(this.debugText == "undefined")
			this.debugText = "";

		this.debugText = text + "<br/>" + this.debugText;
		setInnerXHTML(	"debug" ,"<div>"+ this.debugText + "</div>");
	}
}
/*
Function.prototype.bind = function(scope) {
	  var _function = this;
	  
	  return function() {
	    return _function.apply(scope, arguments);
	  }
	}*/