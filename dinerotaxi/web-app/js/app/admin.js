function doAdminCommentDelete(commentid){
	if(confirm("Do you really want to delete this comment?")){				
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/comment/deleteComment',
			data: "commentid=" + commentid,
			dataType: 'json',
			success: function(data){
				$("#comment_" + commentid).remove();						
			}
		});
	}
}

function doAdminCommentReplyDelete(commentid, replyid){
	if(confirm("Do you really want to delete this reply?")){				
		$.ajax({
			type : 'POST', 
			url: baseAppUrl + '/comment/deleteCommentReply',
			data: "commentid=" + commentid + "&replyid=" + replyid,
			dataType: 'json',
			success: function(data){
				$("#reply_" + commentid + "_" + replyid).remove();						
			}
		});
	}
}
   

function doAdminPostDelete(wallpostID, userId){
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



function doAdminReplyDelete(wallpostID, replyID, userId){
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