technoridesApp.factory '$feedback', ['$api', '$location', '$settings', '$analytics', ($api, $location, $settings, $analytics) ->

  $feedback =

    attributes :
      reason : "Question"
      message: ""


    send : (user) ->
      $analytics.eventTrack("feedback-#{$feedback.attributes.reason}", {category: 'feedback', label: 'feedback' })
      $feedback.attributes.id            = user.id
      $feedback.attributes.email         = user.email
      $feedback.attributes.role          = user.role
      $feedback.attributes.complete_name = "#{user.firstName} #{user.lastName}"
      $feedback.attributes.company       = user.company
      $feedback.attributes.host          = user.host
      $feedback.attributes.rtaxi         = user.rtaxi
      $feedback.attributes.url           = $location.absUrl()
      $feedback.attributes.version       = $settings.version
      $feedback.attributes.environment   = $settings.environment

      emailAttributes                    =
        from   : $settings[$settings.environment].emails.from
        to     : $settings[$settings.environment].emails.to.feedback
        subject: "[#{$feedback.attributes.reason}] New Feedback! (#{$feedback.attributes.company})"
        message: "
          <p>
            <h1>Company Information</h1>
            <ul>
              <li>Rtaxi: #{$feedback.attributes.rtaxi}</li>
              <li>Company: #{$feedback.attributes.company}</li>
              <li>Host: #{$feedback.attributes.host}</li>
            </ul>
          </p>
          <p>
            <h1>User Information</h1>
            <ul>
              <li>ID: #{$feedback.attributes.id}</li>
              <li>Email: #{$feedback.attributes.email}</li>
              <li>Role: #{$feedback.attributes.role}</li>
              <li>Complete Name: #{$feedback.attributes.complete_name}</li>
            </ul>
          </p>
          <p>
            <h1>Technical Information</h1>
            <ul>
              <li>URL: #{$feedback.attributes.url}</li>
              <li>Version: #{$feedback.attributes.version}</li>
              <li>Environment: #{$feedback.attributes.environment}</li>
            </ul>
          </p>
          <p>
            <h1>Message (#{$feedback.attributes.reason})</h1>
            <p>#{$feedback.attributes.message.replace(/\n/, '<br>')}</p>
          </p>
        "
      $api.send 'sendEmail', emailAttributes

      # Close modal
      $(".feedback-modal").modal "hide"

      # Reset form
      $feedback.attributes =
        reason : "Question"
        message: ""


]
