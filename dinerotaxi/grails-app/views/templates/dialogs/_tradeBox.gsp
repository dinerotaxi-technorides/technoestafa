<div class="modal-header">
	<h3>
		<img class="small_icon"
			src="${'https://static.dinerotaxi.com/symbols/icon/'+position.stock.symbol+'.ico'}"
			align="absmiddle" alt="">
		${position?.stock?.symbol}
		-
		<g:capitalize value="${position?.stock?.description.toLowerCase()}" />

	</h3>
	<a href="#" class="close"
		onclick="$('#tradeBoxContainer').fadeOut(); $('#tradeBoxContainer').overlay().close();">×</a>
</div>
<div class="modal-body">
	<div class="symbol_chart clearfix">
		<img id="logoCompany" class="left" align="absmiddle"
			src="${'https://static.dinerotaxi.com/symbols/logo/'+position.stock.symbol+'.gif'}" alt="">
		<img id="graphicCompany" class="right"
			src="http://www.google.com/finance/chart?cht=c&q=${position?.stock?.symbol}&tlf=12h"
			width="250" height="130" alt=""/>
	</div>
	<span class="sp"></span>
	<form name="tradeForm" id='tradeForm'>
		<div class="clearfix">
			<table class="trade-data">
				<tbody>
					<tr>
						<th><g:message code="tradebox.positions" />:</th>
						<td><g:number value="${position?.amount}" format="#" /></td>
					</tr>
					<tr>
						<th><g:message code="tradebox.last_price" />:</th>
						<td><g:number value="${position?.stock.last_price}"
								dollar="true" /></td>
					</tr>
					<tr>
						<th><g:message code="tradebox.cash" />:</th>
						<td><g:number value="${position?.cash}" dollar="true"
								format=",000.00" /></td>
					</tr>
					<tr>
						<th><g:message code="tradebox.order" />:</th>
						<td><input type="radio" checked="" onclick="" value="Market"
							name="tradeType" id="Market"> <label for="Market"><g:message
									code="tradebox.market" /> </label> <input type="radio" onclick=""
							value="Limit" name="tradeType" id="Limit"> <label
							for="Limit"><g:message code="tradebox.limit" /> </label>
						</td>
					</tr>
					<tr>
						<th class="title-price"><g:message code="tradebox.action" />:</th>
						<td><select onChange="setAskOrBid();updatePrice();" id="type"
							name="type" class="trade-actions">
								<g:if test="${position.amount>=0}">
									<option value="BUY" ${type=="BUY"?'selected="selected"':''}>
										<g:message code="tradebox.buy" />
									</option>
									<g:if test="${position.amount>0}">
										<option value="SELL" ${type=="SELL"?'selected="selected"':''}>
											<g:message code="tradebox.sell" />
										</option>
									</g:if>
									<g:else>
										<option value="SHORT"
											${type=="SHORT"?'selected="selected"':''}>
											<g:message code="tradebox.short_sell" />
										</option>
									</g:else>
								</g:if>
								<g:else>
									<option value="SHORT" ${type=="SHORT"?'selected="selected"':''}>
										<g:message code="tradebox.short_sell" />
									</option>
									<option value="COVER" ${type=="COVER"?'selected="selected"':''}>
										<g:message code="tradebox.buy_to_cover" />
									</option>
								</g:else>
						</select></td>
					</tr>
					<tr id="limit_price_row">
						<th><label for="price"><g:message code="tradebox.limit_price" />:</label></th>
						<td><input type="text" onKeyUp="updatePrice(); setLimitPrice();" name="price" maxlength="45" size="20" id="price"></td>
					</tr>
					<tr id="days_valid_row">
						<th><label for="limit_days"><g:message
									code="tradebox.days_valid" />:</label></th>
						<td><input type="text" value="30" name="limit_days"
							maxlength="45" size="20" id="limit_days"></td>
					</tr>

				</tbody>
			</table>
			<input type="hidden" value="${position?.stock?.symbol}" name="symbol" id="symbol">
			<input type="hidden" value="${position?.stock?.description}" name="name" id="name">
			<input type="hidden" value="${position?.amount}" name="owned" id="owned">
			<input type="hidden" value="602.935" name="d_price" id="d_price"> 
			<input type="hidden" value="${position?.cash}" name="cash" id="cash"> 
			<input type="hidden" value="${position?.stock?.bid}" name="bid" id="bid">
			<input type="hidden" value="${position?.stock?.ask}" name="ask"	id="ask"> 
			<input type="hidden" value="${(type=='BUY'||type=='COVER')?'0':'1'}" name="value-bid"
				id="value-bid"> <input type="hidden"
				value="${(type=='BUY'||type=='COVER')?'1':'0'}" name="value-ask"
				id="value-ask"> <input type="hidden" value="1"
				name="value-action" id="value-action"> <input type="hidden"
				value="0" name="publish_permission" id="publish_permission">
		</div>
		<span class="sp"></span>
		<div class="clearfix centre">
			<ul id="quantity-total">
				<li><input type="text" onKeyUp="updatePrice();" maxlength="45"
					size="18" id="amount" name="amount" value="0" class="span-3">
					<h5>
						<g:message code="tradebox.quantity" />
					</h5></li>
				<li class="dsc"><p id="askorbid">x ${(type=="BUY" ||
						type=="SHORT")?position.stock.ask:position.stock.bid} =</p>
					<h5 id="askorbidtext">
						${(type=="BUY" || type=="COVER")?"(Ask)":"(Bid)"}
					</h5></li>
				<li><input type="text" onKeyUp="updateAmount();" name="total"
					maxlength="45" size="18" id="total" value="0" class="span-3">
					<h5>
						<g:message code="tradebox.total" />
					</h5></li>
			</ul>
			<div id="slider" style="margin-bottom: 150px; margin: 0 auto; width: 450px; height: 10px;">
			</div>
		</div>
		<span class="sp"  style="margin:.5em 0"></span>
		<div class="clearfix">
			<ul id="tradeShare" style="margin-top:.5em">
				<li>Share:</li>
				<li style="position: relative; height: 50px;">
				<img class="share_image" src="https://graph.facebook.com/${session.facebookId}/picture" alt="Share with facebook" />
					<h5>Facebook</h5> <input style="position: absolute; right: 3px; bottom: -3px;" type="checkbox" id='postTradeOnFacebook' onclick="saveChanges('POST_FACEBOOK',$(this).is(':checked'))" /></li> 
				<%--				<li>--%>
				<%--					<a id="tw-connect">Connect My Twitter</a>--%>
				<%--				</li>--%>
				<%--				<li><img width="16"--%>
				<%--					src="${resource(dir:'img/share',file:'twitter-off.png')}"--%>
				<%--					title="Tweet Trade" alt="Twitter" class="share_image"--%>
				<%--					onclick="src='${resource(dir:'img/share',file:'twitter.png')}'" />--%>
				<%--					<h5>Twitter</h5>--%>
				<%--				</li>--%>
			</ul>
		</div>
	</form>
</div>
<div class="modal-footer">
	<button id="tradebtn" class="btn disabled large" form="tradeForm" type="button" onclick="">
		<g:message code="tradebox.trade" />
	</button>
	<button class="btn large" id="closeTradeBox">
		<g:message code="button.cancel" />
	</button>
</div>




<!-- Trade PopUp Ends -->

<%--AL VENDER DEBERIAN APARECER POR DEFECTO TODAS LAS ACCIONES--%>

<script type="text/javascript">

	amount = getAmount(parseInt(${position.cash}-10), ${Math.abs(position.amount)});		
	bought = ${position.buyprice?:0};
	amount_owned = ${position.amount.abs()};
	sliderValue = 0;
	sliderStepping = 1;
	sliderMin	= 0;
	sliderMax  = amount; 	
	action = $('.trade-actions').val();
	cash = ${position.cash};
	ask = ${position?.stock?.ask}
	bid = ${position?.stock?.bid}
	updatePrice();
	updateGain(bought);
	initTradebox();

<%--	setAskOrBid(${position?.stock.ask},${position?.stock.bid},'${position?.cash}','${position?.amount.abs()}');--%>
	
	function afterTradeActions(){
		if($("#postTradeOnFacebook").attr("checked")=="checked"){
			var successText = '<g:message code="operations.postTrade.ok"/>';
			var fbaccessToken = '${session.accessToken}';
			var fbClientId = '${session.facebookId }';
			var tradeAction=$("#type").val().toLowerCase().trim();
			var days=$("#limit_days").val().trim();
			var messageText = "";
			if($("#Market").is(":checked")){
				if(tradeAction=="buy"){
					messageText = '${session.facebookName} <g:message code="operations.postTrade.buymarket"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol}';				
				}else if (tradeAction=="sell"){				
					messageText = '${session.facebookName} <g:message code="operations.postTrade.sellmarket"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol}';
				}else if (tradeAction=="short"){				
					messageText = '${session.facebookName} <g:message code="operations.postTrade.shortmarket"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol}';
				}else if (tradeAction=="cover"){				
					messageText = '${session.facebookName} <g:message code="operations.postTrade.covermarket"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol}';
				}
			}else if($("#Limit").is(":checked")){
				if (tradeAction=="buy"){				
					messageText = '${session.facebookName} <g:message code="operations.postTrade.buylimit"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol} <g:message code="operations.postTrade.for"/> ' + days + ' <g:message code="operations.postTrade.days"/>';
				}else if (tradeAction=="sell"){			
					messageText = '${session.facebookName} <g:message code="operations.postTrade.selllimit"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol} <g:message code="operations.postTrade.for"/> ' + days + ' <g:message code="operations.postTrade.days"/>';
				}else if (tradeAction=="short"){			
					messageText = '${session.facebookName} <g:message code="operations.postTrade.shortlimit"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol} <g:message code="operations.postTrade.for"/> ' + days + ' <g:message code="operations.postTrade.days"/>';
				}else if (tradeAction=="cover"){			
					messageText = '${session.facebookName} <g:message code="operations.postTrade.coverlimit"/> ' + ' ' + $("#amount").val() + ' <g:message code="operations.postTrade.SharesFrom"/> ${" " + position?.stock?.symbol} <g:message code="operations.postTrade.for"/> ' + days + ' <g:message code="operations.postTrade.days"/>';
				}
			}			
			postYourTrade(fbClientId, fbaccessToken, 'iframe', messageText, '${position?.stock?.symbol}', successText);
		}				
	}
	
  </script>
