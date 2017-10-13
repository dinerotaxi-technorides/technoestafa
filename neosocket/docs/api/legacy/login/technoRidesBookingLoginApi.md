# Autenticación de usuarios

Este servicio permite la autenticación de un usuario para la parte de booking:

## Request

    http://{endpoint}:2001/v3/technoRidesBookingLoginApi?json={email: #email, rtaxi: #rtaxi, password: #pass}

#### Parametros
Hay que enviar un query param **json** con estos atributos:

1. **email:** el username del usuario que intenta acceder al sistema
2. **rtaxi:** el username de la empresa para la que trabaja el usuario
3. **password:** el pasword del usuario


### Ejemplo

```bash
CURL http://{endpoint}:2001/v3/technoRidesBookingLoginApi?json={email: "1@sutaxi.com.ar",rtaxi: "info@sutaxi.com.ar", password: "2212345"}
```

## Response
```json
{
   "email":"1@sutaxi.com.ar",
   "host":"sutaxi.com.ar",
   "token":"ykSqnFFhouh5hap019cwmr8vmu6K0ooeg4_MnASFRDpQ9maEHvafaebY3E1ntk3V",
   "status":100,
   "lang":"es",
   "latitude":-38.7125,
   "longitude":-62.3012,
   "country":"Argentina",
   "time_zone":"Etc/GMT+3",
   "admin_code":"Ciudad Autónoma de Buenos Aires",
   "driver_quota":20,
   "package_company":"PREMIUM",
   "country_code":"AR",
   "id":5612,
   "is_required_zone":false,
   "use_admin_code":false,
   "first_name":"-----",
   "last_name":"-----",
   "company":"RadioTaxi SuTaxi",
   "rtaxi":5610,
   "roles":"ROLE_TAXI,ROLE_TAXI_OWNER",
   "digitalRadio":false,
   "map_key":"AIzaSyDETwlXKIG-v6rZeV_7uWbuWdpB3IThysI",
   "operatorDispatchMultipleTrips":true,
   "is_chat_enabled":false,
   "is_fare_calculator_enabled":false,
   "credit_card_enable":false,
   "operatorSuggestDestination":true,
   "operatorCancelationReason":false,
   "blockMultipleTrips":true,
   "businessModel":[
      "GENERIC"
   ],
   "showBusinessModel":false,
   "isPrePaidActive":false,
   "googleApiKey":"AIzaSyDVz_ywjT3iiX-xsEIy7z2s8YqseVxTYms",
   "companyPhone":"+54-11-46352500",
   "had_driver_number":false,
   "currency":"USD",
   "has_mobile_payment":false,
   "merchant_id":"",
   "rtaxiId":5610,
   "is_cc":false,
   "is_cc_admin":false,
   "is_cc_super_admin":false,
   "cost_id":null,
   "phone":"----"
}
```