//-----------------------Wall Javascript Functions-----------------------

function getComment(fullWall, quoteToPost){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/comment/getCommentAjax',
		data: "symbol=" + quoteToPost,
		beforeSend: function(){
			$("#CommentLoadMoreStatusDiv").html("<div><img src='/img/loading-bar-evolution.gif' alt='' ></div>");
		},
		dataType: 'html',
		success: function(data){						
			$("#commentsDiv").append(data);						
			$("#CommentLoadMoreStatusDiv").html("");
			setTooltip();
		}				
	});		
}

function getCommentReplies(commentid){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/comment/getRepliesAjax',
		beforeSend: function(){
			$("#morerepliesstatus_" + commentid).html("<div><img src='/img/loading-bar-evolution.gif' alt='' /></div>");
		},
		data: "commentid=" + commentid,
		dataType: 'html',
		success: function(data){
			$("#morerepliesstatus_" + commentid).html("");
			$("#replies_" + commentid).prepend(data);
			setTooltip();
		}	
	});	
}       

$("#commentshareform").submit(function(e){
	e.preventDefault();
	return false;
});		       		

function doAjaxComment(onMaxLengthErrorMessage){
	if($("#new_post_content").val()!=""){
		if($("#new_post_content").val().length<20000){
			$.ajax({
				type : 'POST', 
				url: baseAppUrl + '/comment/postToQuote',
				beforeSend: function(){
					$("#CommentShareStatusDiv").html("<div><img src='/img/loading-bar-evolution.gif' alt='' ></div>");
				},
				data: $("#commentshareform").serialize(),
				dataType: 'html',
				success: function(data){
					$("#commentsDiv").prepend(data);
					$("#CommentShareStatusDiv").html("");
					$("#new_post_content").val("");
					setTooltip();
				}				
			});
		}else{
			showErrorMessage(onMaxLengthErrorMessage);
		}
	}
}


function doLikeComment(commentid, vote){ 
	$.ajax({ 
		type : 'POST', 
		url: baseAppUrl + '/comment/likeCommentAjax', 
		data: "commentid=" + commentid + "&vote=" + vote, 
		dataType: 'html', 
		success: function(data){
			$("#commentLikeBox_" + commentid).html(data); 
		} 
	});
}

function doCommentDelete(commentid,ownerId){
	if(confirm("Do you really want to delete this comment?")){				
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/comment/deleteComment',
			data: "commentid=" + commentid + "&ownerId=" + ownerId,
			dataType: 'json',
			success: function(data){
				$("#comment_" + commentid).remove();						
			}
		});
	}
}

function doCommentReplyDelete(commentid, replyid,ownerId){
	if(confirm("Do you really want to delete this reply?")){				
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/comment/deleteCommentReply',
			data: "commentid=" + commentid + "&replyid=" + replyid + "&ownerId=" + ownerId,
			dataType: 'json',
			success: function(data){
				$("#reply_" + commentid + "_" + replyid).remove();						
			}
		});
	}
}
   
function doCommentRating(commentid, rate){				
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/comment/rateComment',
		data: "commentid=" + commentid + "&rate=" + rate,
		dataType: 'html',
		success: function(data){
			$("#commentRateBox_" + commentid).html(data);
			$("#rating_" + commentid).stars('select', $("#rating_" + commentid + "_avg").html());
			$("#rating_" + commentid).fadeOut(function(){
				$("#commentRateBox_" + commentid).append("<span style='display:none;' class='newrateInfo'>You've just voted " + rate + "</span>");
				$('.newrateInfo').fadeIn(function(){
					setTimeout("$('.newrateInfo').fadeOut();$('.newrateInfo').remove();$('#rating_' + " + commentid + ").fadeIn();", 1500);
				});
			});								
		}
	});
}

// -----------------------
	
function getWall(fullWall, userToPost){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/wall/getWallAjax',
		data: "fullWall=" + fullWall + "&userOwner=" + userToPost,
		beforeSend: function(){
			$("#WPLoadMoreStatusDiv").html("<div><img src='/img/loading-bar-evolution.gif' alt='' ></div>");
		},
		dataType: 'html',
		success: function(data){
			if(fullWall){
				$("#wallPostsDiv").html(data);
			}else{
				$("#wallPostsDiv").append(data);
			}
			$("#WPLoadMoreStatusDiv").html("");
			setTooltip();
		}				
	});		
}

function getReplies(wpostID){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/wall/getRepliesAjax',
		beforeSend: function(){
			$("#morerepliesstatus_" + wpostID).html("<div><img src='/img/loading-bar-evolution.gif' alt='' /></div>");
		},
		data: "wallpostid=" + wpostID,
		dataType: 'html',
		success: function(data){
			$("#morerepliesstatus_" + wpostID).html("");
			$("#replies_" + wpostID).prepend(data);
			setTooltip();
		}				
	});	
}       	

function doAjaxWallPost(onMaxLengthErrorMessage){
	if($("#new_post_content").val()!=""){
		if($("#new_post_content").val().length<20000){
			$.ajax({
				type : 'POST', 
				url: baseAppUrl + '/wall/postToWallAjax',
				beforeSend: function(){
					$("#WPShareStatusDiv").html("<div><img src='/img/loading-bar-evolution.gif' alt='' /></div>");
				},
				data: $("#wallpostshareform").serialize(),
				dataType: 'html',
				success: function(data){
					$("#wallPostsDiv").prepend(data);
					$("#WPShareStatusDiv").html("");
					$("#new_post_content").val("");
					setTooltip();
				}
				
			});
		}else{
			showErrorMessage(onMaxLengthErrorMessage);
		}
	}
}
			
function doAjaxReply(wallpostid, onMaxLengthErrorMessage){
	if($("#reply_" + wallpostid).val()!=""){
		if($("#reply_" + wallpostid).val().length<20000){
			$.ajax({
				type : 'POST', 
				url: baseAppUrl + '/wall/postReply',
				beforeSend: function(){
					$("#morerepliesstatus_" + wallpostid).html("<div><img src='/img/loading-bar-evolution.gif' alt='' /></div>");
				},
				data:$("#replywallpost_" + wallpostid).serialize(),
				dataType: 'html',
				success: function(data){
					$("#morerepliesstatus_" + wallpostid).html("");
					$("#reply_" + wallpostid).val("");
					$("#replywallpost_" + wallpostid).slideUp();
					$("#replies_" + wallpostid).append(data);					
					$("#counter_"+ wallpostid).text(parseInt($("#counter_"+ wallpostid).text())+1);
					setTooltip();
				}				
			});
		}else{
			showErrorMessage(onMaxLengthErrorMessage);
		}		
	}
}

function doAjaxCommentReply(commentid, onMaxLengthErrorMessage){
	if($("#reply_" + commentid).val()!=""){
		if($("#reply_" + commentid).val().length<20000){
			$.ajax({
				type : 'POST', 
				url: baseAppUrl + '/comment/postReply',
				beforeSend: function(){
					$("#morerepliesstatus_" + commentid).html("<div><img src='/img/loading-bar-evolution.gif' alt=''/></div>");
				},
				data:$("#replycomment_" + commentid).serialize(),
				dataType: 'html',
				success: function(data){
					$("#morerepliesstatus_" + commentid).html("");
					$("#reply_" + commentid).val("");
					$("#replycomment_" + commentid).slideUp();
					$("#replies_" + commentid).append(data);	
					setTooltip();					
				}
			});
		}else{
			showErrorMessage(onMaxLengthErrorMessage);
		}		
	}
}

function doLikePost(wallpostid, vote){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/wall/likePostAjax',
		data: "wallpostid=" + wallpostid + "&vote=" + vote,
		dataType: 'html',
		success: function(data){
			$("#wallpostLikeBox_" + wallpostid).html(data);
		}				
	});
}

function doLikeReply(wallpostID, replyid, vote){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/wall/likeReplyAjax',
		data: "replyid=" + replyid + "&vote=" + vote,
		dataType: 'html',
		success: function(data){
			$("#wallpostReplyLikeBox_" + wallpostid + "_" + replyid).html(data);						
		}
	});
}

function doPostDelete(wallpostID, userId){
	if(confirm("Are you sure?")){				
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/wall/deletePost',
			data: "wallpostid=" + wallpostID + "&userId=" + userId,
			dataType: 'json',
			success: function(data){
				$("#wallpost_" + wallpostID).remove();						
			}
		});
	}
}



function doReplyDelete(wallpostID, replyID, userId){
	if(confirm("Are you sure?")){
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/wall/deleteReply',
			data: "wallpostid=" + wallpostID + "&replyid=" + replyID + "&userId=" + userId,
			dataType: 'json',
			success: function(data){
				$("#reply_" + wallpostID + "_" + replyID).remove();
				$("#counter_"+ wallpostID).text(parseInt($("#counter_"+ wallpostID).text())-1);	
			}
		});
	}				
}

function wallpostTemplateReadyActions(wpostID){
// Tags & Links Filter message(message, dollar, hash, at, link)
	$("#post_content_" + wpostID).html(
		taggify(
			$("#post_content_" + wpostID).html(), 
			true, 
			true, 
			true, 
			true
		)
	);
	// Shorten Filter (disabled)
// $("#post_content_" + wpostID).shorten('wallpost_' + wpostID); //TODO fix html
// tags unclosed
	// Symbol Tag Tooltiping
	setTooltip();
	shortenize();
}

function wallpostReplyTemplateReadyActions(wpostID, replyID){
	// Tags & Links Filter message(message, dollar, hash, at, link)
	$("#reply_content_" + wpostID + "_" + replyID).html(
		taggify(
			$("#reply_content_" + wpostID + "_" + replyID).html(), 
			true, 
			true, 
			true, 
			true
		)
	);		
	// Shorten Filter (disabled)
// $("#reply_content_" + wpostID + "_" + replyID).shorten('reply_content_' +
// wpostID + '_' + replyID); //TODO fix html tags unclosed
	// Symbol Tag Tooltiping
	setTooltip();
}

function commentTemplateReadyActions(commentID){
// Tags & Links Filter message(message, dollar, hash, at, link)
	$("#post_content_" + commentID).html(
		taggify(
			$("#post_content_" + commentID).html(), 
			true, 
			true, 
			true, 
			true
		)
	);
	// Shorten Filter (disabled)
// $("#post_content_" + commentID).shorten('comment_' + commentID); //TODO fix
// html tags unclosed
	// Symbol Tag Tooltiping
	setTooltip();	
}

function commentReplyTemplateReadyActions(commentID, replyID){
	// Tags & Links Filter message(message, dollar, hash, at, link)
	$("#reply_content_" + commentID + "_" + replyID).html(
		taggify(
			$("#reply_content_" + commentID + "_" + replyID).html(), 
			true, 
			true, 
			true, 
			true
		)
	);		
	// Shorten Filter (disabled)
// $("#reply_content_" + commentID + "_" + replyID).shorten('reply_content_' +
// commentID + '_' + replyID); //TODO fix html tags unclosed
	// Symbol Tag Tooltiping
	setTooltip();
}	