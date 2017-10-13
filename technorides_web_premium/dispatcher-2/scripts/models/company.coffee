technoridesApp.factory '$company',['company.adapter',($api) ->
  $company =
    configuration : {}
    scheduled : []
    getConfig : (params) ->
      $api.getConfig(
        done : (adapted) ->
          $company.configuration = adapted
          params.done()
      )
    getScheduledConfig: (params) ->
      $api.getScheduledConfig(
        done: (adapted) ->
          adapted.push(
            # Custom time
            name : "Custom"
            time : undefined
            id   : undefined
          )
          adapted.push(
            name : "Default [#{$company.configuration.operations.scheduled.executiontime} min]"
            time : $company.configuration.operations.scheduled.executiontime
            id   : "Default"
          )
          $company.scheduled = adapted
      )
]
