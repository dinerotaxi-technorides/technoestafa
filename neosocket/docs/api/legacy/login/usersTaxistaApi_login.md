# Autenticación de drivers

Este servicio permite a un driver (taxista) autenticarse en el sitio, los roles válidos son:

* ROLE_TAXI
* ROLE_TAXI_OWNER

## Request

    http://{endpoint}:2001/v3/usersTaxistaApi/login?json={"email": #email, "rtaxi": #rtaxi, "password": #password}

#### Parametros
Hay que enviar un query param **json** con estos atributos:

1. **email:** el username del driver que intenta acceder al sistema
2. **rtaxi:** el username de la empresa para la que trabaja el driver
3. **password:** el pasword del driver


### Ejemplo

```bash
CURL http://{endpoint}:2001/v3/usersTaxistaApi/login?json={"email":"1@sutaxi.com.ar", "rtaxi":"info@sutaxi.com.ar", "password":"12345"}
```

## Response
```json
{
   "driver_quota":20,
   "package_company":"PREMIUM",
   "token":"50qrDBeCvx3xq6yBwkbuSptFi12wRDiK1fyG7070b0UK9QokkummBt7ouLZAcBRd",
   "status":100,
   "lang":"es",
   "lat":-38.7125,
   "lng":-62.3012,
   "companyPhone":"+54-11-46352500",
   "country":"Argentina",
   "adminCode":"Ciudad Autónoma de Buenos Aires",
   "use_admin_code":false,
   "countryCode":"AR",
   "id":5612,
   "firstName":"-----",
   "lastName":"-----",
   "phone":"----",
   "plate":"buu777",
   "brandCompany":"2015",
   "model":"Nissan",
   "rtaxiId":5610,
   "poolingTrip":0,
   "driverCancellationReason":false,
   "poolingTripInTransaction":0,
   "hadPaymentRequired":false,
   "hadUserNumber":false,
   "has_mobile_payment":false,
   "has_required_zone":false,
   "is_chat_enabled":false,
   "digitalRadio":false,
   "currency":"USD",
   "newOpshowAddressFrom":false,
   "newOpshowAddressTo":false,
   "newOpshowCorporate":false,
   "newOpshowUserName":false,
   "newOpshowOptions":false,
   "newOpshowUserPhone":false,
   "newOpComment":false,
   "isProfileEditable":true,
   "isQueueTripActivated":false,
   "disputeTimeTrip":20000,
   "driverShowScheduleTrips":true,
   "hasDriverDispatcherFunction":true,
   "isFareCalculatorActive":false,
   "creditCardEnable":false,
   "isPrePaidActive":false,
   "isCorporate":true,
   "isMessaging":null,
   "isPet":null,
   "isAirConditioning":null,
   "isSmoker":null,
   "isSpecialAssistant":null,
   "isLuggage":null,
   "isAirport":null,
   "isVip":true,
   "isInvoice":null,
   "isRegular":true,
   "fareInitialCost":0,
   "fareCostPerKm":0,
   "fareConfigActivateTimePerDistance":1000,
   "fareConfigGracePeriodMeters":0,
   "fareConfigGraceTime":0,
   "fareConfigTimeSecWait":0,
   "fareConfigTimeInitialSecWait":0,
   "fareCostTimeWaitPerXSeg":0,
   "fareCostTimeInitialSecWait":0,
   "distanceType":"",
   "googleApiKey":"AIzaSyDVz_ywjT3iiX-xsEIy7z2s8YqseVxTYms",
   "additionals":[

   ],
   "businessModel":[
      "GENERIC"
   ]
}
```