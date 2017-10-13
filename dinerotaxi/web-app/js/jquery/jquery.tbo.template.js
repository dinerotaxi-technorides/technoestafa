(function($){

    $.fn.editable = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).tabs(customOptions) });
            return this;
        }

        // SETUP private variables;
        var base = this;

        // setup options
        var defaultOptions = {
            //default options go here.
            beforeLoad : function() {
                            // do something .
                        },
            afterLoad : function() {
                            // do something .
                        },
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
            return base;
        };
       
        var findTabs = function() {
            // do something .
        };
        
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);

