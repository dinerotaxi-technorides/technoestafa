jQuery.fn.shorten = function(targetId, settings) {
  var config = {
    showChars : 300,
    ellipsesText : "...",
    moreText : "more",
    lessText : "less"
  };

  if (settings) {
    $.extend(config, settings);
  }

  $('.morelink_' + targetId).live('click', function() {
    var $this = $(this);
    if ($this.hasClass('less')) {
      $this.removeClass('less');
      $this.html(config.moreText);
    } else {
      $this.addClass('less');
      $this.html(config.lessText);
    }
    $this.parent().prev().toggle();
    $this.prev().toggle();
    return false;
  });

  return this.each(function() {
    var $this = $(this);

    var content = $this.html();
    if (content.length > config.showChars) {
      var c = content.substr(0, config.showChars);
      var h = content.substr(config.showChars , content.length - config.showChars);
      var html = c + '<span class="moreellipses">' + config.ellipsesText + '&nbsp;</span><span class="morecontent_' + targetId + '"><span>' + h + '</span>&nbsp;&nbsp;<a href="javascript://nop/" class="morelink_' + targetId + '">' + config.moreText + '</a></span>';
      $this.html(html);
      $(".morecontent_" + targetId + " span").hide();
    }
  });
};