if(navigator.userAgent.toLowerCase().indexOf("chrome") == -1) {
  alert(I18n.panels.operator.invalid_browser);
  document.location = "http://www.google.com/chrome";
}
