# Autenticación de usuarios

Este servicio permite la autenticación de un usuario que tenga los siguientes roles:

* ROLE_COMPANY
* ROLE_ADMIN
* ROLE_OPERATOR
* ROLE_COMPANY_ACCOUNT
* ROLE_COMPANY_ACCOUNT_EMPLOYEE
* ROLE_TELEPHONIST
* ROLE_INVESTOR
* ROLE_MONITOR

## Request

	https://{endpoint}:2001/v3/technoRidesLoginApi/login?json={email:#email, password:#pass}

#### Parametros
Hay que enviar un query param **json** con estos atributos:

1. **email:** el username del usuario
2. **password:** el pasword del usuario


### Ejemplo

```bash
CURL http://{endpoint}:2001/v3/technoRidesLoginApi/login?json={email: "operador@sutaxi.com.ar", password: "2212345"}
```

## Response
```json
{
   "email":"operador@sutaxi.com.ar",
   "host":"sutaxi.com.ar",
   "token":"74-cmkyAqTsxgdygfA73ptleVODRuw3TPIQxHnNpxoEcjD9oBb-Riw9IrRatLSqB",
   "package_company":"PREMIUM",
   "driver_quota":20,
   "status":100,
   "lang":"es",
   "latitude":-38.7125,
   "longitude":-62.3012,
   "country":"Argentina",
   "time_zone":"Etc/GMT+3",
   "admin_code":"Ciudad Autónoma de Buenos Aires",
   "country_code":"AR",
   "id":5611,
   "is_required_zone":false,
   "use_admin_code":false,
   "first_name":"caputo",
   "last_name":"pedro",
   "company":"RadioTaxi SuTaxi",
   "rtaxi":5610,
   "roles":"ROLE_EMPLOY,ROLE_OPERATOR",
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
   "isPrePaidActive":false
}
```