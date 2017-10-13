<table id="pending-dividends" class="listings tablesorter" style="background-color: white;">
	<caption>${message(code:'order.pending_'+type)}</caption>
<%--	<a class="help right" title='${message(code:'help.'+type)}'>?</a>--%>
	<thead>
      	<tr>
	      	<th><g:message code="order.id"/></th>
	        <th><g:message code="order.order"/></th>
	        <th><g:message code="order.company"/></th>
	        <g:if test="${type =='dividends'}">
	        	<th><g:message code="order.payout"/></th>
	        </g:if>
	        <g:else>
	        	<th><g:message code="order.price"/></th>
	        </g:else>
	        <th><g:message code="order.type"/></th>
	        <th><g:message code="order.quantity"/></th>
	        <th><g:message code="order.total"/></th>
	        <g:if test="${type == 'dividends'}">
	        	<th><g:message code="order.paydate"/></th>
	        </g:if>
	        <g:else>
	        	<th><g:message code="order.expires"/></th>
	        </g:else>
	       	<g:if test="${type != 'dividends'}">
		        <th><g:message code="order.remove"/></th>
	        </g:if>
     	</tr>
	</thead>
 		    
    <tbody class="small">
	    <g:if test="${orders?.size()>0}">
	    	<g:each in="${orders}" var="order">
			    <tr>
			     	<td>${order.id}</td>
			        <td>${order.type}</td>
			        <td align="left" class="symbol" onMouseOver="loadingGraphic('${order.symbol}')"><a href="${createUrl(value:'/quotes/'+order.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+order.symbol+'.ico'}" alt="" class="small_icon" /></a><a href="${createUrl(value:'/quotes/'+order.symbol)}">${order.symbol}</a></td>
			        <g:if test="${type == 'dividends'}">
			        	<td class="payout"><g:number value="${order.payout}" dollar=""/></td>
			        </g:if>
			        <g:else>
			        	<td class="price"><g:number value="${order.price}" dollar=""/></td>
			        </g:else>
			        <td class="type">${order.amount>0?order.transtype:order.transtype=='BUY'?'SHORT':'COVER'}</td>
			        <td><g:number value="${order.amount}" absolute="true" letters="true" format="###,###"/></td>
			       	<g:if test="${type == 'dividends'}">
	        			<td class="total">
	        				<g:number value="${(order.payout*order.amount)}" color="true" absolute="true" dollar="true" letters="true"/>
	        			</td>
	        		</g:if>
	        		<g:else>
				        <td class="total">
				        	<g:number value="${(order.price*order.amount)}" color="true" absolute="true" dollar="true" letters="true"/>
				        </td>
	        		</g:else>
			        
			        <g:if test="${order.type == 'MARKET'}">
						<td><g:message code="order.never"/></td>      
			        </g:if>
			        <g:else>
			        	<g:if test="${type != 'dividends'}">
				        	<td><span>${order.limit_date.split(" ")[0]}</span></td>
				        </g:if>
				        <g:else>
				        	<td><span>${order.pay_date.split(" ")[0]}</span></td>
				        </g:else>
			        </g:else>
				    <g:if test="${type != 'dividends'}">
			        	<td class="centre"><button class="btn danger smll" onclick="removeOrder(${order.id})">X</button></td>
			        </g:if>
				</tr>
	    	</g:each>
	    </g:if>
	    <g:else>
	    	<g:if test="${type == 'dividends'}">
				<td class="no_data" colspan="8">No data</td>
			</g:if>
			<g:else>
	    		<td class="no_data" colspan="10">No data</td>
			</g:else>
	    </g:else>
    </tbody>
</table>
