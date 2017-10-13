technoridesApp.directive 'typedTranslate', ['$filter', '$company', '$compile', '$translate', ($filter, $company, $compile, $translate) ->
  link: (scope, element, attrs) ->
      scope.$watch ->
        # When company businessModel changes...
        $translate.use() + $company.info.businessModel if $company and $company.info isnt undefined
      , (value) ->
        if $company? and $company.info isnt undefined
          # ask_for key
          translateKey = element[0].getAttribute('typed-translate') # typed-translate="key"

          if translateKey is ""
            translateKey = element.html().trim() # typed-translate=""
            attrs.$set "typed-translate", translateKey

          # ask_for_taxi key
          typedTranslateKey = "#{translateKey}_#{$company.info.businessModel}"

          # ask_for_taxi translation
          translation = $filter('translate')(typedTranslateKey)

          # Unless ask_for_taxi exists? use ask_for
          if (translation is typedTranslateKey)
            translation = $filter('translate')(translateKey)

          if translation is translateKey or translation is typedTranslateKey
            console.warn "#{translateKey} is not defined"

          # Replace text with translated text
          element.html translation
]
