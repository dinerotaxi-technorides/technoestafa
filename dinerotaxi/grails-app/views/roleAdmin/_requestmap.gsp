

<div class="container" style="max-width: 100%; margin: 0 auto;">
	<div class="row">
		<div class="col-md-12">
			<form id="demoform" action="#" method="post">
				<select multiple="multiple" size="10" name="duallistbox_demo1[]">
					<g:each var="requestmap" in="${requestMaps}">
						<option value="${requestmap.url}" selected="selected">
							${requestmap.url}
						</option>
					</g:each>
					<g:each var="requestmapNotSelected" in="${requestss}">
						<option value="/${requestmapNotSelected.logicalPropertyName}/**">
							${"/"+requestmapNotSelected.logicalPropertyName+"/**"}
						</option>
					</g:each>

				</select> <br>
				<button type="submit" class="btn btn-default btn-block">Submit
					data</button>
			</form>
			<script>
				var demo1 = $('[name="duallistbox_demo1[]"]')
						.bootstrapDualListbox({
							nonselectedlistlabel : 'Non-selected',
							selectedlistlabel : 'Selected',
							preserveselectiononmove : 'moved',
							moveonselect : false,
							initialfilterfrom : ''
						});
				$("#demoform").submit(function() {
					$.ajax({
						type : "POST",
						url : "updateAll",
						contentType : "text/plain",
						dataType : 'json',
						data : JSON.stringify({
							urls : $('[name="duallistbox_demo1[]"]').val(),
							role : $('#roleddl').val()
						}),//JSON.stringify(,),
						 success: function(result) {
							alert( result.message);
						},
		                error: function(result) {
		                    alert(result.message);
		                }
					});
					return false;
				});
			</script>
		</div>
	</div>



</div>