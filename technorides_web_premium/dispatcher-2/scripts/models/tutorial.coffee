technoridesApp.factory '$tutorial',() ->
  window.onresize = ->
    if $tutorial.on
      $tutorial.resized()
  $tutorial =
    on : false
    steps    :[
      {
        event      : 'click'
        selector   : '.btn-compose-email'
        description: 'Click the "New" button to start creating trips'
        event_type : 'new-trip-visible'
      }
      {
        timeout     : 500
        selector    : '#new-trip-phone'
        description : 'Choose an existing user, type a phone number to search, and wait to sugestions to apear'
        showNext    : true
        event_type  : 'next'
      }
      {
        selector    : '#passengers-suggestions'
        event       : 'click'
        description : 'Select a existing user, new users will be automatically created'
      }
      {
        selector    : '#search-origin-address-sugestion'
        event       : 'click'
        description : 'Choose suggested address, this will locate the operation origin marker'
      }
      {
        selector    : '#search-origin-address'
        event_type  : 'next'
        description : 'You can change the address if you need or enter a new one, notice the marker in the map, yeap, we know its awesome ;)'
      }
      {
        selector    : '#create-new-trip'
        event       : 'click'
        description : 'Dont worry, you can delete this trip, you can also add comments and more options, but basically this is how you create a trip.'
      }
      {
        selector    : '#goto-pending'
        event       : 'click'
        description : 'Go check the trip you created!'
        showNext    : true
        event_type  : 'go-to-pending'
      }
      {
        timeout     : 500
        selector    : '#pending-operations-screen'
        event       : 'click'
        description : 'Now you can see your operation in the list of pending operations, you can cancel the trip we created if you want!'
      }

    ]

    setSteps : (steps) ->
      $tutorial.steps = steps

    trigger : (eventName) ->
      if $tutorial.instance?
        $tutorial.instance.trigger(eventName)


    run : (step) ->
      $tutorial.on = true
      $tutorial.instance = new EnjoyHint({
        onEnd: ->
          window.scrollTo(0,0)
          $tutorial.on = false
        onSkip: ->
          window.scrollTo(0,0)
          $tutorial.on = false
        })
      $tutorial.instance.set $tutorial.steps
      if step
        $tutorial.runFromStep step
      else
        $tutorial.instance.run()

    resized : ->
      step = $tutorial.instance.getCurrentStep()
      $tutorial.instance.stop()
      $tutorial.run(step)
