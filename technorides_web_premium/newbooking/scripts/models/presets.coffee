technoridesApp.factory '$presets', ->
  $presets =
    payments :
      methods : [
        {name:"Cash"}
        {name:"CreditCard"}
        {name:"BankTransfer"}
      ]
