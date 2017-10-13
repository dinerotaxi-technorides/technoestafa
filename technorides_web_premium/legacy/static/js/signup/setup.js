// Assigns all data to the fields
function loadData(step) {
  $.each($("form input:not([type=submit]), form select"), function(index, value) {
    var that   = $(value);
    var cookie = $.cookie("signup_step_" + step + "__" + that.attr("name"));

    if(that.attr("type") == "checkbox") {
      if(cookie == "true") {
        console.log("changeee");
        that.attr("checked", false);
        that.click();
      }
    } else {
      that.val(cookie);
    }
  });
}

// Save all data fields data into cookies
function saveData(step) {
  $.each($("form input:not([type=submit]), form select"), function(index, value) {
    that = $(value);
    if(that.attr("type") == "checkbox") {
      $.cookie("signup_step_" + step + "__" + that.attr("name"), that.is(":checked"), {"path": "/"});
    } else {
      $.cookie("signup_step_" + step + "__" + that.attr("name"), that.val(), {"path": "/"});
    }
  });
}

// Returns all the cookies data
function getData() {
  cookies = {};
  $.each(document.cookie.split("; "), function(index, cookie) {
    splittedCookie = cookie.split("=");
    key            = splittedCookie[0];
    value          = splittedCookie[1];
    if(key.indexOf("signup_step_") > -1 && key.indexOf("__") > -1) {
      key          = key.split("__")[1];
      cookies[key] = value;
    }
  });

  return cookies;
}

// Should send email?
function shouldSendEmail(step) {
  return $.cookie("signup_step_" + step + "__email_sent") != "true";
}

// Email sent?
function emailSent(step) {
  return $.cookie("signup_step_" + step + "__email_sent", "true", {"path": "/"});
}

// Clear all cookies data
function clearData() {
  $.each(document.cookie.split("; "), function(index, cookie) {
    splittedCookie = cookie.split("=");
    key            = splittedCookie[0];
    if(key.indexOf("signup_step_") > -1) {
      $.removeCookie(key, {"path": "/"});
    }
  });
}

// Get last signup step number
function getLastStep() {
  lastStep   = parseInt($.cookie("signup_step_last"));
  if(isNaN(lastStep))
    lastStep = 1;
  return lastStep;
}

// Set an step as current step
function setAsLastStep(step) {
  if(step >= getLastStep())
    $.cookie("signup_step_last", step, {"path": "/"});
}

// Verify current step
function verifyCurrentStep(step) {
  return getLastStep() >= step;
}

// Redirect to current step
function redirectToCurrentStep() {
  splittedPath                          = window.location.pathname.split("/");
  splittedPath[splittedPath.length - 1] = getLastStep();
  location.href                         = splittedPath.join("/");
}

// Show loader
function loader(should_close) {
  if(should_close != true) {
    $.loader(
      {
        content: window.I18n.signup.loading
      }
    );
  } else {
    $.loader("close");
  }
}
