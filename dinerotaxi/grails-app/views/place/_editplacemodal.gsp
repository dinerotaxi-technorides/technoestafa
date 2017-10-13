<div id="modal-wrapper" class="editable">
<article id="modal">
	<!-- <div class="modal-flash error">
		<p>Sorry, an error prevented you from saving this information.</p>
	</div> -->
	
	<div id="modal-body">
	  <form method='POST' class="simplemodal-submit" autocomplete='off' accept-charset="utf-8">
			
			<div class="field">
				<div class="field-label">
					<label for="coke">Places</label>
					<p>Please enter here</p>
				</div>
				
				<div class="field-input">
				  <div class="field-group deleteable">
					  <input type="text" id="placeinput"  pre="${place.destinationListJson1()}"  map="#map_canvas"/>
				  </div>
          <div class="field-group">
            <div id="map_canvas" class="google-map" style="width:288px; height:200px"></div>
          </div>              

					<div class="button-area">
            <input type="submit" name="submit" value="Save" id="submit" class="button-submit primary" />
            <input type="submit" name="submit" value="Cancel" id="submit" class="button-submit simplemodal-close" />
					</div>
				</div>
			</div>
			
		</form>
	</div>
</article>
</div> 
