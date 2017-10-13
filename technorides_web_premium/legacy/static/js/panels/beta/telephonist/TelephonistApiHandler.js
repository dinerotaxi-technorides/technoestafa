function TelephonistApiHandler() {
  // Token Update
  this.onTokenUpdated = function(success, data) {}

  this.onPriceGot = function(success, data) {
  	if(success) {
		$("#new_operation_price").val(data.amount);
  	}
  }
}

// Inheritance
TelephonistApiHandler.inherits(ApiHandler);
