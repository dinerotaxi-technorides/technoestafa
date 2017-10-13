technoridesApp.constant '$settings',

    environment                : 'production'
    version                    : "1.2.3"
    unstableVersion            : false
    imgUrl                     : 'http://technorides.biz/images/'
    zoneDefaultSize            : 0.01
    paypalMerchantId           : "matias@dinerotaxi.com"
    intervals:
      saveBadge             : 2500
      versionDetector       : 300000
      mapResize             : 2500
      maxRadioMessageLength : 110000
      updateWeather         : 115000

    production              :
      api                   : 'https://dinerotaxi.com/'
      websocket             : 'wss://technorides.co:8344/'
      newApi                : 'https://technorides.co:8443/'
      bookingLink           : 'http://technorides.biz'
      debug                 : false
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "support@technorides.com"
          contact           : "adwords@technorides.com"
          juan              : "demo@technorides.com"
      statistics            :
        days                : 7
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'

    development             :
      api                   : 'http://54.232.177.148'
      websocket             : 'ws://54.232.177.132:8345/'
      newApi                : 'http://54.232.177.132:8843'
      bookingLink           : 'localhost:8000/booking/'
      debug                 : false
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "juanc@technorides.com"
          contact           : "juanc@technorides.com"
          juan              : "juan@technorides.com"
      statistics            :
        days                : 365
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'

    localhost               :
      api                   : 'http://localhost:8080/'
      websocket             : 'ws://localhost:8345/'
      newApi                : 'http://localhost:8843/'
      bookingLink           : 'localhost:8000/booking/'
      debug                 : true
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "juanc@technorides.com"
          contact           : "juanc@technorides.com"
          juan              : "juan@technorides.com"
      statistics            :
        days                : 365
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'

    mati                    :
      api                   : 'http://10.250.106.106:8080/'
      websocket             : 'ws://10.250.106.106:8345/'
      newApi                : 'http://10.250.106.106:8843/'
      bookingLink           : 'localhost:8000/booking/'
      debug                 : false
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "juanc@technorides.com"
          contact           : "juanc@technorides.com"
          juan              : "juan@technorides.com"
      statistics            :
        days                : 365
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'

    alpha                   :
      api                   : 'http://alpha-dinerotaxi-com-1284633901.sa-east-1.elb.amazonaws.com/'
      websocket             : 'ws://54.232.177.132:8345/'
      newApi                : 'http://54.232.177.132:8843/'
      bookingLink           : 'localhost:8000/booking/'
      debug                 : false
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "juanc@technorides.com"
          contact           : "emmanuel.bravo@technorides.com"
          juan              : "juan@technorides.com"
      statistics            :
        days                : 365
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'

    beta                :
      api                   : 'https://dinerotaxi.com/'
      websocket             : 'wss://technorides.co:8344/'
      newApi                : 'https://technorides.co:8443/'
      bookingLink           : 'http://technorides.biz'
      debug                 : true
      emails                :
        from                : "no-reply@technorides.com"
        to                  :
          feedback          : "juanc@technorides.com"
          contact           : "juanc@technorides.com"
          juan              : "juan@technorides.com"
      statistics            :
        days                : 365
      intervals             :
        scheduledOperations : 10000
        statistics          :
          menu              :
            drivers         : 1000
            others          : 10000
        validateToken       : 15000
      googleSearch          : true
      midwareUrl            : 'https://technorides.eu/google/'
