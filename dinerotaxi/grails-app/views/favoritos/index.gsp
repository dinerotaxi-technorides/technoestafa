<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
	<meta name="layout" content="home" />
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <link rel="stylesheet" href="${resource(dir:'css',file:'fileuploader.css')}" />
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'json2.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.tokeninput.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <jq:plugin name="multiplace"/>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
    <!-- This JavaScript snippet activates those tabs --> 
    <script> 
        // perform JavaScript after the document is scriptable.
      $(function() {
      
        function onShowAvatar (dialog) {
          var uploader = new qq.FileUploader({
            element: document.getElementById('file-uploader'),
            action: "${createLink(controller:'picture', action:'ajaxavatar')}",
            allowedExtensions: ['jpg', 'jpeg', 'png'],
            multiple: false,
            debug: true,
            params: { param1: 'value1', param2: 'value2' },
            onComplete: function(id, fileName, responseJSON){
              $("#avatar-preview").attr('src', responseJSON.url);
              $("#avatar-url").attr('value', responseJSON.url);
            }
          });            
        }        
      
        $(".profile-image.editable").editable({containerId:'simplemodal-editable', onShowCallback: onShowAvatar});  
      
        function customCallback (params) {
            say('custom');
            $('#placeInput').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '#map_canvas',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShow (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            $('#placeInput').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '.google-map',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShowMessage (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            
            $('#to').tokenInput(
              this.attr('search'), {
              theme: "tbo",
              hintText: "",
              prePopulate: eval(this.attr('prepopulate'))
            });      
        }
                
        function onShowBasicdata (dialog) {
            $('#placeinput').multiplace({tokenLimit: 1});
        }        
        function onShowSpec (dialog) {
            $('#specialities').multiselect({tokenLimit: 4});
        }
        function onShowLang (dialog) {
            $('#languages').multiselect({tokenLimit: 10});
        }
        function onShowDest (dialog) {
            $('#placeinput').multiplace({tokenLimit: 5});
        }        
        function onSubmitProduct (data) {
            // simulates similar behavior as an HTTP redirect
            window.location.replace(data);
        }
        
        function onEditStringAttribute (dialog) {
            $('#stringAttrib').multiselect({tokenLimit: 5});
        }

              
        $(".destinations.editable").editable({onShowCallback: onShowDest});
        
        $(".following.button").follow();
        
        $(".profile-masthead.editable").editable({containerId:'simplemodal-editable', onShowCallback: onShowBasicdata});

        var maintab = $("ul.tabs").tabs("div.panes > div", {
          effect: 'ajax',
          onClick: function(event, i) {
            var pane = this.getPanes().eq(i);
            console.log("%s: %o", 'onClick', pane.find(".editable") );
            pane.find(".mod-body").newscomment();
            pane.find(".why-us.editable").editable({containerId:'simplemodal-editable', onShowCallback: onEditStringAttribute});
            pane.find(".add-product").editable({containerId:'simplemodal-container', onSubmitCallback:onSubmitProduct});
            pane.find('.destinations.editable').editable({containerId:'simplemodal-editable', onShowCallback: onShowDest});
            pane.find('.specialities.editable').editable({containerId:'simplemodal-editable', onShowCallback: onShowSpec});
            pane.find('.languages.editable').editable({containerId:'simplemodal-editable', onShowCallback: onShowLang});
            pane.find('.send-message').editable({containerId:'simplemodal-container', onShowCallback: onShowMessage});
            
            pane.find('#viewallproducts').bind('click', function (e) {
                console.log("%s: %o", 'onClick view all products', e );
                $("ul.tabs").data("tabs").click(1);
                e.preventDefault();
                return false;
            });            
          }
        });
      });

    </script>    
</head>
<body>	
<div id="wrapper">
   <aside id="sidebar">
	<section class="snapshot">
		<header>
			<h2>Basic details</h2>
		</header>

		<dl class="destinations editable" url="${createLink(controller:'place', action:'editmodal', params:[realm:'company.speciality'])}">
			<dt>Destinations</dt>
        <div class="updateable">
			    <place:destinationList comp="${user}"/>
			</div>
		</dl><%--
		
		<dl class="specialities editable"
		      url="${createLink(controller:'lookupLink', action:'edit', params:[realm:'company.speciality'])}">
 			<dt>Specialities</dt>
			<div class="updateable">
			  <g:lookupList facet="speciality" realm="company.speciality" lookupable="${user}"/>
			</div>
		</dl>
		
		<dl class="languages editable"
		      url="${createLink(controller:'lookupLink', action:'edit', params:[realm:'user.language'])}">
			<dt>Languages</dt>
			<div class="updateable">
			  <g:lookupList facet="language" realm="user.language" lookupable="${user}" />
			</div>
		</dl>
	--%></section>
	
	
</aside>


</div>
            
</body>
</html>
