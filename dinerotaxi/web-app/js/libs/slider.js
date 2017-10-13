/*
*  Slider v2.1 (2007)
*  This code is public domain (no copyright).
*/

var slider_handle = '<span style="text-align:center;padding:0 10px;" >| | |</span>';

function slider(obj, min, max, size, input, initial, attachTo) {
		this.container = document.createElement('div');
        this.container.style.width = size + 'px';
//	    this.container.style.width = 100 + '%';
        this.container.className = 'slider';

        this.obj = document.createElement('div');

        this.handle = document.createElement('span');
        
        $(this.handle).html(slider_handle);
        $(obj).append(this.container);
        $(this.container).append(this.obj);
        $(this.obj).append(this.handle);

        this.mousedown = 0;
        this.lastPos = 0;
        this.min = min;
        this.max = max;
        this.input = input;
        this.attachTo = attachTo;
        //var handleScrollWidth = parseInt(this.handle.getScrollWidth());
        
        //Chrome and Safari check
        //if(handleScrollWidth == 0)
        var handleScrollWidth = 34;
        this.width = parseInt(this.obj.scrollWidth) - handleScrollWidth - 8;

        //this.attachTo.addEventListener('mouseup', this.mouseup.bind(this))
        //                         .addEventListener('mousemove', this.mousemove.bind(this));
        //this.input.addEventListener('keyup', this.change.bind(this));
        
        //this.obj.addEventListener('mousedown', this.mdown.bind(this));

        
        $(this.attachTo).mouseup(this.mouseup.bind(this));
        $(this.attachTo).mousemove(this.mousemove.bind(this));
        $(this.input).keyup(this.change.bind(this));
        $(this.obj).mousedown(this.mdown.bind(this));
        

        var num = parseInt(initial);
        if (num > this.max)
                num = this.max;
        if (num < this.min)
                num = this.min;
        var move = parseInt(((num - this.min) / (this.max - this.min)) * (this.width));
        this.handle.style.marginLeft = move + 'px';
        this.input.value = num;
}

slider.prototype.mousemove = function(e) {
	if (this.mousedown != 0) {
                var move = e.pageX - this.lastPos;
                this.lastPos = e.pageX;
                if (this.handle.style.marginLeft)
                        move += parseInt(this.handle.style.marginLeft);
                if (move > this.width)
                        move = this.width;
                if (move < 0)
                        move = 0;
                this.handle.style.marginLeft = move + 'px';
                this.input.value = parseInt(((move / this.width) * (this.max - this.min)) + this.min);
                updatePrice();
                e.preventDefault();
        }
};

slider.prototype.mouseup = function(e) {
	this.mousedown = 0;
};

slider.prototype.mdown = function(e) {
		this.mousedown = 1;
		this.lastPos = e.pageX;
        //TODO
		var offset = $(this.obj).offset();
		var move = parseInt(this.lastPos - offset.left/*this.obj.getAbsoluteLeft()*/ - (this.handle.scrollWidth / 2));
        if (move > this.width)
                move = this.width;
        if (move < 0)
                move = 0;
        
        this.handle.style.marginLeft = move+"px";
        this.input.value = parseInt(((move / this.width) * (this.max - this.min)) + this.min);
        updatePrice();
        e.preventDefault();
};
// update slider on input box change
slider.prototype.change = function(e) {
		var num = 0;
        if(e) {
			if (this.input.value)
	                num = parseInt(this.input.value + String.fromCharCode(e.keyCode));
	        else
	                num = parseInt(String.fromCharCode(e.keyCode));
        }
        else {
        	if (this.input.value)
        		num = parseInt(this.input.value);
        }
		if (num >= this.max)
                num = this.max;
		if (num < this.min)
                num = this.min;
		if(isNaN(num))
			num = this.min;
        
        var move = parseInt(((num - this.min) / (this.max - this.min)) * (this.width));
        this.handle.style.marginLeft = move + 'px';
		
	   return true;
};


slider.prototype.setMax = function(max){
	this.max = max;
	this.handle.style.marginLeft = 0 + 'px';
	this.input.value = 0;
};

Function.prototype.bind = function(scope) {
	  var _function = this;
	  
	  return function() {
	    return _function.apply(scope, arguments);
	  }
	}
