technoridesApp.directive 'ngUnique', ($http, $api, $settings, $company, $modal) ->
  require: 'ngModel'
  link: (scope, elem, attrs, ctrl) ->
    elem.on 'blur', (evt) ->
      scope.$apply ->
        val = elem.val()
        req = 'email': val
        validate = (x)  ->

          regex = new RegExp(/^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i)

          m = regex.test(x)

          return m

        if validate(val) is true
          $api.get
            url : "#{$settings[$settings.environment].api}usersApi/isAvailable"
            data :
              email : val.toLowerCase()
              rtaxi : $company.info.adminMail
            code : 109
            codeName : "status"
            done : (response) ->
              console.log "invalid"
              ctrl.$setValidity 'unique', false
              $modal.open(
                temp : "views/modal/booking/email-exists.html"
                title : "Error"
              )
            fail : (response) ->
              console.log "valid"
              ctrl.$setValidity 'unique', true
