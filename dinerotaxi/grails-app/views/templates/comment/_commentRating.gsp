<form id='rating_${comment.id}' class='right'>
	<input type="radio" name="rate_${comment.id}" value="1" title="<g:message code='commentrating.poor'/>" id="rate1" /> 
	<input type="radio" name="rate_${comment.id}" value="2" title="<g:message code='commentrating.fair'/>" id="rate2" /> 
	<input type="radio" name="rate_${comment.id}" value="3" title="<g:message code='commentrating.average'/>" id="rate3" /> 
	<input type="radio" name="rate_${comment.id}" value="4" title="<g:message code='commentrating.good'/>" id="rate4" /> 
	<input type="radio" name="rate_${comment.id}" value="5" title="<g:message code='commentrating.excelent'/>" id="rate5" /> 
</form>
<g:if test="${comment.ratings.size()>0}">
	<%def avg=0.0;%>
	<g:each in="${comment.ratings }" var="rating">
		<%avg+=rating.rating;%>
	</g:each>
	
	<span style="display:none" id='rating_${comment.id}_avg'>${Math.round(avg/comment.ratings.size())}</span>
	
<%--	<g:message code="ratings.basedon"/> ${comment.ratings.size() } <g:message code="ratings.votes"/>--%>
</g:if>
<%--<g:else>--%>
<%--	<g:message code="ratings.notrated"/>--%>
<%--</g:else>--%>
<script type="text/javascript">
//$(document).ready(function(){
	$("#rating_${comment.id}").children().not(":radio").hide();
	$("#rating_${comment.id}").stars({
		cancelShow: false,
		callback: function(ui, type, value)
		{
			doCommentRating(${comment.id}, value);			
		}
	});
	$("#rating_${comment.id}").stars('select', $("#rating_${comment.id}_avg").html());
//});
</script>