# Autenticación de pasajeros

Este servicio permite a un pasajero autenticarse en el sitio.

## Request

    http://{endpoint}:2001/v3/usersApi/login/?json={"email": #email, "rtaxi": #rtaxi, "password": #password}

#### Parametros
Hay que enviar un query param **json** con estos atributos:

1. **email:** el username del pasajero que intenta acceder al sistema
2. **rtaxi:** el username de la empresa a la que el pasajero quiere pedirle taxis
3. **password:** el pasword del pasajero


### Ejemplo

```bash
CURL http://{endpoint}:2001/v3/usersApi/login/?json={"email": "angelamariahs1@gmail.com", "rtaxi": "info@radiotaxipidalo.com.ar", "password": "2212345"}
```

## Response
```json
{
   "googleApiKey":"AIzaSyDVz_ywjT3iiX-xsEIy7z2s8YqseVxTYms",
   "token":"Vmj8aEGPYM8qXninEZVbHnxlRfyP-XC6h_3ozKaf8oBecc60cw9JmbP_v2m4Olw9",
   "status":100,
   "lat":-34.5628,
   "lng":-58.4752,
   "companyPhone":"+54-11-4956-1200",
   "lang":"es",
   "country":"Argentina",
   "time_zone":"Etc/GMT+3",
   "admin_code":"Ciudad Autónoma de Buenos Aires",
   "useAdminCode":false,
   "had_driver_number":false,
   "country_code":"AR",
   "id":16359,
   "currency":"USD",
   "isFareCalculatorActive":false,
   "creditCardEnable":false,
   "has_mobile_payment":false,
   "merchant_id":"",
   "rtaxiId":6,
   "is_cc":false,
   "is_cc_admin":false,
   "is_cc_super_admin":false,
   "cost_id":null,
   "is_required_zone":false,
   "firstName":"Angel",
   "lastName":"Hernandez",
   "phone":"3134774186",
   "email":"angelamariahs1@gmail.com",
   "businessModel":[
      "GENERIC"
   ],
   "roles":[
      "ROLE_USER"
   ]
}
```