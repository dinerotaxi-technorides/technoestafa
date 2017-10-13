technoridesApp.factory "$user",["api.user","ipCookie","$location","$webSocket","$modal", "$route",( $api, ipCookie, $location, $webSocket, $modal, $route) ->
  $user  =
    elements : ["token","city","name","lastName","email","phone","isLogged","superUser","id","corporate","company","corporateAdmin","requiredZone","lang","latitude","longitude","costCenter","countryCode","companyPhone","country","mobilePayment","timeZone"]
    profileScreen : true
    cookie:
      load : (rtaxi) ->
        $user.rtaxi = rtaxi
        for element in $user.elements
          $user[element] = ipCookie "newbooking_#{element}_#{rtaxi}"

        # if not cookie, set logged to false and empty user
        $user.isLogged = false unless $user.isLogged?
        if not $user.isLogged
          for element in $user.elements
            $user[element] = null

      save   : (key, item, rtaxi) ->
        ipCookie "newbooking_#{key}_#{rtaxi}", item, { path: '/newbooking' }

      delete : (rtaxi) ->
        for element in $user.elements
          ipCookie.remove "newbooking_#{element}_#{rtaxi}", { path: '/newbooking' }
    login : (user, rtaxi) ->
      $api.login({
        data: user
        code: 100
        codeName: "status"
        # adapt response
        done: (response) ->
          for key,item of response
            $user[key] = item
            $user.cookie.save(key, item, rtaxi)
          $user.password = null
          if $user.corporateAdmin
            $location.path "/corporate"
          else
            $location.path "/booking"
        fail: (response) ->
          $user.password = null
          $user.email = null
          if response.status is 105
            $modal.open(
              temp : "views/modal/booking/login-account-locked.html"
              title : "Error"
            )
          else
            $modal.open(
              temp : "views/modal/booking/login-error.html"
              title : "Error"
            )
      })
    logout : (rtaxi) ->
      $user.cookie.delete(rtaxi)
      for element in $user.elements
        $user[element] = null
      $user.isLogged = false
      $webSocket.close()
      $location.path "/"

    getFavorites : ->
      $api.getFavorites(
        id : $user.id
        token: $user.token
        done : (adapted) ->

        fail : (response) ->
          if response.status is 411
            $user.logout()

      )

    edit : ->
      $api.edit(
        user : $user
        done : ->
          # Resave on cookies the new data
          ipCookie "newbooking_name_#{$user.rtaxi}", $user.name, { path: '/newbooking' }
          ipCookie "newbooking_lastName_#{$user.rtaxi}", $user.lastName, { path: '/newbooking' }
          ipCookie "newbooking_phone_#{$user.rtaxi}", $user.phone, { path: '/newbooking' }
          $modal.open(
            temp: "views/modal/booking/edit-profile-success.html"
            title : "Congrats!"
          )
        fail : (response) ->
          if response.status is 411
            $user.logout
          else
            $modal.open(
              temp: "views/modal/booking/edit-profile-error.html"
              title : "Error"
            )
      )

    sendEmail : (email) ->
      $api.sendEmail
        email : email
        done : (adapted) ->
          $modal.open(
            temp : "views/modal/booking/email-success.html"
            title : "Congrats"
          )

        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            $modal.open(
              temp : "views/modal/booking/email-error.html"
              title : "Error"
          )
    contact : (email) ->
      $api.contact
        email : email
        done :  ->
          $modal.open(
            temp : "views/modal/booking/email-success.html"
            title : "Congrats"
          )
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            $modal.open(
              temp : "views/modal/booking/email-error.html"
              title : "Error"
          )
    signUp : (rtaxi) ->
      switch $user.userType
        when "passenger"
          $api.signUp
            user : $user
            done : (response) ->
              for key, item of response
                $user[key] = item
                $user.cookie.save(key, item, rtaxi)
              $user.password = null
              $location.path "/booking"
            fail : (response) ->
              $modal.open(
                temp : "views/modal/booking/sign-up-error.html"
                title : "Error"
              )
        when "enterprise"
          $api.registerEnterprise
            email : $user
            done : (response) ->
              $user.name = ""
              $user.lastName = ""
              $user.email = ""
              $user.password = ""
              $user.phone = ""
              $modal.open(
                temp : "views/modal/booking/sign-up-enterprise.html"
                title : "Success"
              )
            fail : (response) ->
              $modal.open(
                temp : "views/modal/booking/sign-up-error.html"
                title : "Error"
              )
        when "driver"
          $api.registerDriver
            email : $user
            done : () ->
              $user.name = ""
              $user.lastName = ""
              $user.email = ""
              $user.password = ""
              $user.phone = ""
              $modal.open(
                temp : "views/modal/booking/sign-up-driver.html"
                title : "Success"
              )
            fail : () ->
              $modal.open(
                temp : "views/modal/booking/sign-up-error.html"
                title : "Error"
              )
    editPassword :  ->
      $api.editPassword
        token : $user.token
        pass:
          new: $user.newPassword
          current : $user.password
        done : (adapted) ->
          ipCookie "newbooking_token_#{$user.rtaxi}", adapted.token, { path: '/newbooking' }
          $user.token = adapted.token
          $user.newPassword = null
          $user.password = null
          $user.repeatNewPassword = null

          $modal.open
              temp : "views/modal/booking/password-change-success.html"
              title : "Congrats"

        fail : (response) ->
          if response.status is 3
            $modal.open
              temp : "views/modal/booking/password-change-short.html"
              title : "Error"
          if response.status is 4
            $modal.open
              temp : "views/modal/booking/password-change-incorrect.html"
              title : "Error"
            $user.newPassword = null
            $user.password = null
            $user.repeatNewPassword = null
          if response.status is 411
            $user.logout()

    forgotPassword : (rtaxi) ->
      $api.forgotPassword
        email: $user.email
        rtaxi : rtaxi
        done : ->
          $user.email = null
          $modal.open
            temp: "views/modal/booking/forgot-password-success.html"
            title: "Sended"
        fail : (response) ->
          $modal.open
            temp: "views/modal/booking/forgot-password-error.html"
            title: "Error"


]
