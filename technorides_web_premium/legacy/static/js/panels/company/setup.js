// Company
company   = new Company(
  {
    id: companyId,
    rtaxi: companyRtaxi,
    name: companyName,
    domain: companyDomain,
    latitude: companyLatitude,
    longitude: companyLongitude
  }
);

map       = null;

var panel = new Panel(
  {
    company: company,
    map    : map
  }
);
panel.api = new Api(
  {
    baseUrl       : apiBaseUrl,
    reloginUrl    : apiReloginUrl,
    token         : apiToken,
    maxFavorites  : maxFavorites,
    defaultCountry: defaultCountry,
    defaultCcode  : defaultCcode,
    handler       : new CompanyApiHandler()
  }
);

$(function() {
  panel.api.getConfiguration();

  // Update jqGrid
  // this is only used in company panel, #FIXME!
  updateJqGrid();
});

$("#form_save_dialog").dialog({
  autoOpen : false,
  resizable: false,
  buttons  : [{
    text : I18n.panels.operator.accept,
    click: function() {
      // Dialog Close
      $(this).dialog("close");
    }
  }],
  open : function() {},
  close: function() {}
});
