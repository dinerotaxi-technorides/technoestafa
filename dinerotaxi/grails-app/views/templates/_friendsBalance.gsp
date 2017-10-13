<tr>
	<td>
		<g:if test="${!error}">
			<div id="chart_div"></div>
			<g:javascript>
				$(document).ready(function(){
					var data = new google.visualization.DataTable();
			    	data.addColumn('string', 'Day');
			    	
			    	<g:each in="${users}" var="user" status="x">
					    data.addColumn('number','${user.name}');
				    </g:each>
			
			   		<g:each in="${dates}" var="date" status="x">
			   			 data.addRow(["${formatDate (date:new Date(date.key.replace('-','/')), format:"MMM-d") }", <%= date.value.values.collect{it.value}.join(",") %>]);
				    </g:each>
					    
				    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
				    chart.draw(data,{baselineColor:'lightgrey',colors:['navy','lightgray','lightblue','green','red','blue','black','orange','purple','gray'],vAxis:{format:'$###,###',textStyle:{fontSize: 11}},hAxis:{direction:-1,slantedText:false,slantedTextAngle:0,textStyle:{fontSize: 11}},fontSize: 12, backgroundColor:{stroke:'lightgray',strokeWidth:0},enableInteractivity:false,width: (isFacebook?'730':'975'), height: (isFacebook?'300':'300'),chartArea:{left:80,top:20,width:"(isFacebook?'68%':'75%')",height:"80%"}});
					
				});
			</g:javascript>
		</g:if>
		<g:else>
			<g:if test="${facebookerror}">
				<div class="error center">
					<g:message code="error.expired"/>
					<g:form controller="ssconnect" action="facebook" name="loginFormFacebook" align="center" style="margin-top: 5px;margin-bottom: 5px;" >            
<%--				    	<input type="hidden" name="scope" value="user_about_me,read_friendlists">--%>
				    	<input type="hidden" name="scope" value="email" />
						<span onclick="socialLogin('Facebook')" class="fb-connect"></span>
	           		</g:form>
				</div>
			</g:if>
			<g:else>
				<div class="error center">
					<g:message code="error.problem_ocurred"/>
				</div>
			</g:else>
		</g:else>
	</td>
</tr>
