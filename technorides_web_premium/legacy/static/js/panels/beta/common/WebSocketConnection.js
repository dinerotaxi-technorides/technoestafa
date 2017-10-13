function WebSocketConnection(args) {
  this.host                      = args.host;
  this.port                      = args.port;
  this.panel                     = args.panel;
  this.panel.webSocketConnection = this;
  this.company                   = this.panel.company;
  this.map                       = this.panel.map;
  this.userType                  = args.userType;

  // Generate webSocketAddress
  this.generateWebSocketAddress = function() {
    return "ws://" +
      this.host + ":" + this.port +
      "/" + this.userType +
      "?rtaxi=" + this.company.rtaxi +
      "&id=" + this.company.id +
      "&token=" + panel.api.token +
      "&email=" + panel.company.email +
      "&rtaxi_id=" + panel.company.rtaxi;
  }

  this.webSocketAddress          = this.generateWebSocketAddress();
  this.pingInterval              = null;
  this.handler                   = args.handler;
  this.handler.connection        = this;
  this.transport                 = new ReconnectingWebSocket(this.webSocketAddress);
  this.transport.that            = this;

  // Loader
  loader();

  // Upgrade webSocketAddress
  this.upgradeWebSocketAddress = function(args) {
    this.userType = args["userType"];
    this.transport.url = this.generateWebSocketAddress();
    this.transport.URL = this.generateWebSocketAddress();
  }


  // Send message
  this.send = function(data) {
    // Adding required data
    data.security_email = panel.company.email;
    data.rtaxi_id       = panel.company.rtaxi;
    data.token          = panel.api.token;

    // Data
    data = JSON.stringify(data);

    // Log
    if(panel.debug)
      console.debug(">> " + data);

    // Message
    this.transport.send(data);
  }

  // Events
  this.transport.onopen = function(data) {
    console.log("Connected");

    // Clear Interval
    clearInterval(this.that.pingInterval);

    this.that.pingInterval = setInterval(
      function() {
        panel.webSocketConnection.send(
          {
            action: "company/Ping",
            id: panel.company.id,
            rtaxi: panel.company.rtaxi
          }
        )
      },
      10000
    )

    // Loader
    loader(true);

    // Handler
    this.that.handler.onOpen(data);
  }

  this.transport.onclose = function(data) {
    console.log("Disconnected");
    switch(data.code) {
      case 3000:
        // Stop Reconnecting
        panel.webSocketConnection.transport.stopReconnecting();
        
        // Logout
        var cookies = $.cookie();
        for(var cookie in cookies) {
          $.removeCookie(cookie, { path: '/' });
        }
        location.href="/login";

        break;
    }

    // Loader
    loader();

    // Handler
    this.that.handler.onClose(data);
  }

  this.transport.onmessage = function(data) {
    // Log
    if(panel.debug)
      console.debug("<< " + data.data);

    // JSON
    json = $.parseJSON(data.data);

    // Need confirmation?
    if(json.message_need_confirmation == true) {
      // Read confirmation
      this.that.send(
        {
          action: "messenger/ReadMessage",
          message_id: json.message_id
        }
      );
    }

    // Handler
    this.that.handler.onMessage(json);
  }
}

// Loader
function loader(should_close) {
  // Should close?
  if(should_close != true) {
    $.loader(
      {
        content: window.I18n.panels.operator.connecting
      }
    );
  } else {
    $.loader("close");
  }
}
