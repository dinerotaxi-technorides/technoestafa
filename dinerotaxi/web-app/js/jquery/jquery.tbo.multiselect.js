(function($){

    $.fn.multiselect = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() {
              $(this).multiselect(customOptions)
            });
            return this;
        }

        // SETUP private variables;
        var base = this;
        var count = 0;
        
        // Keys "enum"
        var KEY = {
          BACKSPACE: 8,
          TAB: 9,
          ENTER: 13,
          ESCAPE: 27,
          SPACE: 32,
          PAGE_UP: 33,
          PAGE_DOWN: 34,
          END: 35,
          HOME: 36,
          LEFT: 37,
          UP: 38,
          RIGHT: 39,
          DOWN: 40,
          NUMPAD_ENTER: 108,
          COMMA: 188
        };

        // setup options
        var defaultOptions = {
            //default options go here.
            beforeLoad : function() {
                            // do something .
                        },
            afterLoad : function() {
                            // do something .
                        },
            debug : false,
            pre : null,
            val : '',
            field : '<div>', // <div class="field-group deleteable">
            input : '<input>', // <input type="text" name="coke" value="Ski" id="coke" readonly="readonly" />
            link  : '<a>', // <a class="delete" href="">Delete</a></div>
            group : null,
            preventDuplicates: false,
            tokenLimit: null,
            hiddenvaluename: 'values[]'
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
//            console.log("%s: %o", 'multiselect init', base);
            options.group = base.closest("div.field-group");
            options.fieldinput = base.closest("div.field-input");
            options.search = base.attr("search");
            options.pre = base.attr("pre");
            prePopulate();
            bindEvents();
            return base;
        };
        
        var addPlace = function(value, id) {
//            console.log("%s: %o", 'multiselect add place', base);
            
            var fieldItem = $('<div>')
            .addClass('field-group field-value deleteable')
            //.insertAfter(options.group)
            .insertBefore(options.group)

            if(options.search){
              // if autocomplete is used add hidden value for the code/id
              var hiddenItem = $(options.input)
              .attr('type', 'hidden')
              .addClass('hidden-value')
              .val(id)
              .appendTo(fieldItem)
              
               var inputItem = $(options.input)
              .attr('type', 'text')
              .addClass('text-value')
              .val(value)
              .appendTo(fieldItem)
            }
            else{
              // if free text value then use text field as both code/id and value
               var inputItem = $(options.input)
              .attr('type', 'text')
              .addClass('hidden-value')
              .addClass('text-value')
              .val(value)
              .appendTo(fieldItem)            
            }
                                    
            var linkItem = $(options.link)
            .addClass('delete')
            .attr('href', '')
            .appendTo(fieldItem)
            
            linkItem.bind('click.multiselect',function(e){
              e.preventDefault();
              deletePlace(this);
            });
            
            count++
            checkTokenLimit();
            updateHiddenValueNames();
            $(fieldItem).keydown(keydownExistingFieldHandler);
            
            return inputItem
        };
        
        var prePopulate = function() {
            var data = eval (options.pre);
            if(options.pre){
                $.each(data, function (i, value) {
                    addPlace(value.name, value.id);
                });
            }
        }
        
        var updateHiddenValueNames = function() {
          $(options.fieldinput).find('.hidden-value').each(function(i){
            var itemname = options.hiddenvaluename.replace('[]','[' + i + ']');
            $(this).attr('name', itemname);
          });
        }

        var deletePlace = function(item) {
//          console.log("%s: %o", 'multiselect delete place', base);
          $(item).unbind('.multiselect');
          $(item).closest('div.field-group').remove();
          $(base).show();
          updateHiddenValueNames();
          count--;
        };
        
        var checkTokenLimit = function () {
          if(options.tokenLimit !== null && count >= options.tokenLimit) {
            $(base).hide();
            return;
          }
        };
        
        var keydownExistingFieldHandler = function(event) {
            switch(event.keyCode) {
                case KEY.TAB:
                case KEY.ENTER:
                case KEY.NUMPAD_ENTER:
//                  console.log("%s: %o", 'multiselect add item: ' + $(this).val(), base);
                  var next = $(this).next().find('.text-value');
                  if(next.length==0){
                	  if($(base).is(":visible")){ 
                          next = $(base)
                          if(next.length==0){
                              break;
                          }
                      }
                	  else{
                		  break;
                	  }
                  }
                  next.focus();
                  return false;
                  break;
            }          
          };
        
        var keydownHandler = function(event) {
          switch(event.keyCode) {
              case KEY.LEFT:
              case KEY.RIGHT:
              case KEY.UP:
              case KEY.DOWN:
                  if(!$(this).val()) {
                  }
                  break;

              case KEY.BACKSPACE:
                  break;

              case KEY.TAB:
              case KEY.ENTER:
              case KEY.NUMPAD_ENTER:
                break;

              case KEY.ESCAPE:
                break;
                
              default:
//                console.log("%s: %o", 'multiselect add item: ' + $(this).val(), base);
                if($(this).val().length==0) {
                  var res = addPlace($(this).val(), $(this).val())
                  $(this).val("");
                  res.focus();
                }
                break;
          }          
        };
        
        var bindEvents = function () {alert("s");
            // bind the close event to any element with the closeClass class
            $(base).bind('click.multiselect', function (e) {
                e.preventDefault();
//                console.log("%s: %o", 'multiselect click ' + options.val, base);
            });
            
            if(options.search){
//              console.log("%s: %o", 'multiselect autocomplete=true', base);
              $(base).autocomplete({
                  source: options.search,
                  select: function(event, ui) {
                    $(this).val("");
                    addPlace(ui.item.value, ui.item.code)
                    return false;
                  }                
              });
            }
            else{
//              console.log("%s: %o", 'multiselect autocomplete=false', base);
              $(base).keydown(keydownHandler);
            }
        };
               
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);

