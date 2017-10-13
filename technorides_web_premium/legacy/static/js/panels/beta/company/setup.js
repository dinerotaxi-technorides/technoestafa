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
    handler       : new ApiHandler()
  }
);

// Update jqGrid
// this is only used in company panel, #FIXME!
updateJqGrid();
