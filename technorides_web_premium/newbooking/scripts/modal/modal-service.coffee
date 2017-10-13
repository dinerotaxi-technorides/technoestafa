technoridesApp.factory '$modal', ($rootScope) ->
  $modal =
    temp  : ""
    close : false
    backdrop : true
    title    : ""
    open : (options) ->
      #Template mandatory, penalty punish by death
      unless options.temp?
        throw new Error "Modal Service: Template parameter is mandatory"
        return

      $modal.temp = options.temp

      # Optionals parameters
      $modal.close = options.close?=false
      $modal.title = options.title?=""
      $modal.backdrop = options.backdrop?=true
      $("#async").modal("show")

      #safe return to avoid html return (this causes angular to crash)
      undefined
    apply : ->
      $rootScope.$broadcast('modalApply')

    closeIt : ->
      $("#async").modal("hide")
