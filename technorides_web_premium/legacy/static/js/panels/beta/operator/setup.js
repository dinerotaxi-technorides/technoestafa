// Tabs
$("#operations_container").tabs(
  {
    active        : 0,
    beforeActivate: function(event, ui) {
      if(ui.newPanel.attr("id") == "scheduled_operations_tab")
        panel.api.getScheduledOperations();
    }
  }
);

// Resizable
$("#map").resizable(
  {
    handles  : "s",
    maxHeight: parseInt($("#panel").height() - $("#header").height() - 160),
    minHeight: parseInt($("#header").height() + 400),
    resize   : function(event, ui)
    {
      resizeMap();
    }
  }
);

function resizeMap() {
  // Height
  newHeight = parseInt($("#panel").height() - $("#header").height() - $("#map").height() - 5);
  $("#grid").css("height", newHeight);
  $(".operations_tab").css("height", parseInt((newHeight + 10) - $(".ui-tabs-nav").height() - $($(".operations_tab .ui-widget-header")[0]).height()));
}

$(window).resize(
  function() {
    resizeMap();
  }
);

$(document).ready(
  function() {
    resizeMap();
  }
)

// Right Click
$(document).contextmenu(
{
    delegate: ".pending_operation",
    menu    : "#contextmenu",
    position: function(event, ui) {
      return {
        my: "left top",
        at: "left bottom",
        of: ui.target
      };
    },
    open    : function(event, ui) {
      // Operation ID
      operationId = ui.target.parent().attr("rel");

      // Rel
      $("#contextmenu li a").attr("rel", operationId);
    }
  }
);

// Right Click (can't use same selector)
$("#grid").contextmenu(
{
    delegate: ".intransaction_operation",
    menu    : "#contextmenu_intransaction",
    position: function(event, ui) {
      return {
        my: "left top",
        at: "left bottom",
        of: ui.target
      };
    },
    open    : function(event, ui) {
      // Operation ID
      operationId = ui.target.parent().attr("rel");

      // Rel
      $("#contextmenu_intransaction li a").attr("rel", operationId);
    }
  }
);

// Right Click (can't use same selector)
$("#grid #operations_container").contextmenu(
{
    delegate: ".scheduled_operation",
    menu    : "#contextmenu_scheduled",
    position: function(event, ui) {
      return {
        my: "left top",
        at: "left bottom",
        of: ui.target
      };
    },
    open    : function(event, ui) {
      // Operation ID
      operationId = ui.target.parent().attr("rel");

      // Rel
      $("#contextmenu_scheduled li a").attr("rel", operationId);
    }
  }
);

// Tabs
$(document).on("click", "#operations_container ul li a",
  function() {
    // Sound
    playSuccessSound();
  }
);

// Button
$(".button").button();

// Context Menu
$(".menu").menu();

// Find Driver
$(document).on("click", "a.find_driver_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#find_driver_operation_operation_id").text(operationId);

    // Dialog
    $("#find_driver_operation_dialog").dialog("open");
  }
);

// Ring User
$(document).on("click", "a.ring_user_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#ring_user_operation_operation_id").text(operationId);

    // Dialog
    $("#ring_user_operation_dialog").dialog("open");
  }
);

// In Transaction
$(document).on("click", "a.in_transaction_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#in_transaction_operation_operation_id").text(operationId);

    // Dialog
    $("#in_transaction_operation_dialog").dialog("open");
  }
);

// Cancel
$(document).on("click", "a.cancel_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#cancel_operation_operation_id").text(operationId);

    // Dialog
    $("#cancel_operation_dialog").dialog("open");
  }
);

// Cancel
$(document).on("click", "a.cancel_scheduled_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#cancel_scheduled_operation_operation_id").text(operationId);

    // Dialog
    $("#cancel_scheduled_operation_dialog").dialog("open");
  }
);

// Finish
$(document).on("click", "a.view_operation_link",
  function() {
    // Zoom
    panel.map.setZoom(panel.map.zoom);
    // Operation
    operation = panel.company.operations[parseInt($(this).attr("rel"))];
    // Show
    panel.map.panTo(operation.latitude, operation.longitude);
  }
);

// Finish
$(document).on("click", "a.finish_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#finish_operation_operation_id").text(operationId);

    // Dialog
    $("#finish_operation_dialog").dialog("open");
  }
);

// Driver Panel
$(document).on("click", "a#driver_panel_link",
  function() {
    // Dialog
    $("#driver_panel_dialog").dialog("open");
  }
);

// Assign
$(document).on("click", "a.assign_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#assign_operation_operation_id").val(operationId);
    // Dialog
    $("#assign_operation_dialog").dialog("open");
  }
);

// Set Amount
$(document).on("click", "a.set_amount_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#set_amount_operation_operation_id").val(operationId);
    // Dialog
    $("#set_amount_operation_dialog").dialog("open");
  }
);

// Tutorial
$("#tutorial_link").click(
  function() {
    $("#tutorial_dialog").dialog("open");
  }
);

// Help
$("#help_link").click(
  function() {
    $("#zenbox_tab").click();
  }
);

// Settings
$("#settings_link").click(
  function() {
    $("#settings_dialog").dialog("open");
  }
);

$("#settings_theme").change(
  function() {
    applyTheme($(this).val());
  }
);

// Logout
$("#logout_link").click(
  function() {
    // Dialog
    $("#logout_dialog").dialog("open");
  }
);

// Pan to my location
$("#pan_to_my_location_link").click(
  function() {
    panel.map.showAllMarkers();
  }
);

// Dialogs
// Assign
$("#assign_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#assign_operation_operation_id").val());

          // Driver Number
          driverNumber = parseInt($("#assign_operation_driver_number").val());

          // Estimated Time
          estimatedTime = parseInt($("#assign_operation_estimated_time").val());

          // Driver?
          if(!isNaN(operationId) && !isNaN(driverNumber) && !isNaN(estimatedTime)) {
            // Assign
            panel.company.assignOperation(operationId, driverNumber, estimatedTime);

            // Sound
            playSuccessSound();

            // Dialog Close
            $(this).dialog("close");
          } else {
            $("#form_error_dialog").dialog("open");
          }
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Sound
          playSuccessSound();

          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open: function() {
      // Sound
      playAnswerSound();

      // Online Drivers
      onlineDrivers = [];
      $.each(company.drivers,
        function(index, item) {
          if(item.status == "ONLINE") {
            onlineDrivers.push(item.number.toString());
          }
        }
      );

      // Clear Val
      $("#assign_operation_driver_number").val("");

      // Autocomplete
      $("#assign_operation_driver_number").autocomplete(
        {
          source: onlineDrivers
        }
      );
    },
    close: function() {
      $("#assign_operation_form input").val("");

      // Sound
      playSuccessSound();
    }
  }
);

// Set Amount
$("#set_amount_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#set_amount_operation_operation_id").val());

          // Amount
          amount = parseInt($("#set_amount_operation_amount").val());

          // Driver?
          if(!isNaN(operationId) && !isNaN(amount)) {
            // Assign
            panel.company.setOperationAmount(operationId, amount);

            // Sound
            playSuccessSound();

            // Dialog Close
            $(this).dialog("close");
          } else {
            $("#form_error_dialog").dialog("open");
          }
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Sound
          playSuccessSound();

          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      $("#set_amount_operation_form input").val("");

      // Sound
      playSuccessSound();
    }
  }
);

// Show Driver
function showDriver(driverNumber) {
  // Remove animations
  $.each(panel.map.markers,
    function(index, item) {
      if(item != undefined && item.marker != undefined) {
        item.marker.setAnimation(null);
      }
    }
  );

  // Marker
  marker = panel.map.markers["driver_" + driverNumber];
  if(marker != null && marker != undefined) {
    marker.marker.setAnimation(google.maps.Animation.DROP);
    panel.map.panTo(marker.latitude, marker.longitude);
    panel.map.setZoom(16);
  }
}

// Driver Panel
$("#driver_panel_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {

          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open: function() {
      // Clear Val
      $("#driver_panel_driver_id").val("");

      // Sound
      playAnswerSound();
    },
    close: function() {
      showDriver($("#driver_panel_driver_id").val());

      // Sound
      playSuccessSound();
    }
  }
);

$("#driver_panel_driver_id").keyup(function() {
  showDriver($(this).val());
});

// In Transaction
$("#in_transaction_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#in_transaction_operation_operation_id").text());
          panel.company.inTransactionOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#in_transaction_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Find Users
$("#find_driver_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#find_driver_operation_operation_id").text());
          panel.company.findDriverOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#find_driver_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Ring User
$("#ring_user_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#ring_user_operation_operation_id").text());
          panel.company.ringUserOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#ring_user_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Cancel
$("#cancel_scheduled_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#cancel_scheduled_operation_operation_id").text());
          if(panel.api.token != null) {
            panel.api.cancelScheduledOperation(operationId);
          }

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#cancel_scheduled_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Assign
$(document).on("click", "a.assign_scheduled_operation_link",
  function() {
    // Operation ID
    operationId = $(this).attr("rel");
    $("#assign_scheduled_operation_operation_id").val(operationId);
    // Dialog
    $("#assign_scheduled_operation_dialog").dialog("open");
  }
);

// Dialogs
// Assign
$("#assign_scheduled_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#assign_scheduled_operation_operation_id").val());

          // Driver Number
          driverNumber = parseInt($("#assign_scheduled_operation_driver_number").val());

          // Driver?
          if(!isNaN(operationId) && !isNaN(driverNumber)) {
            // Assign
            panel.api.assignScheduledOperation(operationId, driverNumber);

            // Sound
            playSuccessSound();

            // Dialog Close
            $(this).dialog("close");
          } else {
            $("#form_error_dialog").dialog("open");
          }
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Sound
          playSuccessSound();

          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open: function() {
      // Sound
      playAnswerSound();

      // Online Drivers
      onlineDrivers = [];
      $.each(company.drivers,
        function(index, item) {
          if(item.status == "ONLINE") {
            onlineDrivers.push(item.number.toString());
          }
        }
      );

      // Clear Val
      $("#assign_scheduled_operation_driver_number").val("");

      // Autocomplete
      $("#assign_scheduled_operation_driver_number").autocomplete(
        {
          source: onlineDrivers
        }
      );
    },
    close: function() {
      $("#assign_scheduled_operation_form input").val("");

      // Sound
      playSuccessSound();
    }
  }
);


// Cancel
$("#cancel_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#cancel_operation_operation_id").text());
          panel.company.cancelOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#cancel_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Finish
$("#finish_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#finish_operation_operation_id").text());
          panel.company.finishOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#finish_operation_operation_id").text("");
          $(this).dialog("close");
        }
      },
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Another Driver
$("#another_driver_assigned_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playErrorSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Error
$("#offline_driver_error_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playErrorSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Error
$("#invalid_driver_error_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playErrorSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Error
$("#form_error_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playErrorSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Logout
$("#logout_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Logout

          var cookies = $.cookie();
          for(var cookie in cookies) {
            $.removeCookie(cookie, { path: '/' });
          }
          window.location.href = "/login";
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Dialog
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function()
    {
      // Sound
      playSuccessSound();
    }
  }
);

// Settings
$("#settings_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Cookie

          createCookie("technorides_mute", $("#settings_mute").prop("checked"), 99999);

          themeName = $("#settings_theme").val();
          createCookie("technorides_theme", themeName, 99999);

          languageName = $("#settings_language").val();
          createCookie("technorides_language", languageName, 99999);
          applyLanguage(languageName);

          timezone = $("#settings_timezone").val();
          createCookie("technorides_timezone", timezone, 99999);
          panel.company.timezone = timezone;

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Settings
          readSettings();

          // Dialog
          $(this).dialog("close");
        }
      },
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// New Trip Sound
function playNewTripSound() {
  playSound("#new_trip_sound");
}

// Success Sound
function playSuccessSound() {
  playSound("#success_sound");
}

// Error Sound
function playErrorSound() {
  playSound("#error_sound");
}

// Success Answer
function playAnswerSound() {
  playSound("#answer_sound");
}

// Play Sound
function playSound(soundId) {
  // Mute?
  if(!$("#settings_mute").prop("checked"))
    $(soundId).get(0).play()
}

// Create Cookie
function createCookie(name, value, days) {
  if(days) {
    var date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    var expires = "; expires=" + date.toGMTString();
  }
  else var expires = "";
  document.cookie = escape(name) + "=" + escape(value) + expires + "; path=/";
}

// Read Cookie
function readCookie(name) {
  var nameEQ = escape(name) + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1, c.length);
    if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
  }
  return null;
}

// Erase Cookie
function eraseCookie(name) {
  createCookie(name, "", -1);
}

// Generate Timezones list
$.each(WallTime.zones, function(key, value) {
  $("#settings_timezone").append("<option value='" + key + "'>" + key.replace("/", ", ").replace("/", ", ").replace("_", " ").replace("_", " ") + "</option>");
  // if(key.indexOf("/") > -1 && key.indexOf("-") == -1 && key.indexOf("+") == -1 && key.indexOf("Etc") == -1)
  //   $("#settings_timezone").append("<option value='" + key + "'>" + key.replace("/", ", ").replace("/", ", ").replace("_", " ").replace("_", " ") + "</option>");
});
$("#settings_timezone").sort_select_box();

// Settings
function readSettings() {
  $("#settings_mute").prop("checked", readCookie("technorides_mute") == "true");

  themeName = readCookie("technorides_theme");
  if(themeName == null || themeName == undefined)
    themeName = "dark-hive";
  $("#settings_theme").val(themeName);
  applyTheme(themeName);

  languageName = readCookie("technorides_language");
  language = "es"
  if(languageName == null || languageName == undefined)
    languageName = language;
  $("#settings_language").val(languageName);

  if(language != languageName)
    applyLanguage(languageName);

  timezone = readCookie("technorides_timezone");
  if(timezone == null || timezone == undefined) {
    if(panel != undefined && panel.company != undefined) {
      timezone = panel.company.timezone;
    } else {
      timezone = companyTimezone;
    }
  } else {
    if(panel != undefined && panel.company != undefined) {
      panel.company.timezone = timezone;
    }
  }
  $("#settings_timezone").val(timezone);
}

// First call
readSettings();

// Apply theme
function applyTheme(themeName) {
  $("head").append("<link rel='stylesheet' type='text/css' href='http://code.jquery.com/ui/1.10.3/themes/" + themeName + "/jquery-ui.css'>");
}

// Apply language
function applyLanguage(languageName) {
  urlPath = window.location.pathname;
  location.href = "/" + languageName + urlPath.substr(3, urlPath.length - 3);
}

// Hover table style
$(document).on("mouseenter", "tbody.ui-widget-content tr",
  function() {
    $(this).addClass("ui-state-highlight");
  }
);

$(document).on("mouseleave", "tbody.ui-widget-content tr",
  function() {
    $(this).removeClass("ui-state-highlight");
  }
);

$(".map_controls_counter").click(function() {
  $($(this).attr("rel")).click();
});

$("#show_online_drivers_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showOnlineDrivers = !panel.showOnlineDrivers;
  panel.showOrHideAllMarkersBasedOnState();
});

$("#show_offline_drivers_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showOfflineDrivers = !panel.showOfflineDrivers;
  panel.showOrHideAllMarkersBasedOnState();
});

$("#show_intravel_drivers_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showIntravelDrivers = !panel.showIntravelDrivers;
  panel.showOrHideAllMarkersBasedOnState();
});

$("#show_disconnected_drivers_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showDisconnectedDrivers = !panel.showDisconnectedDrivers;
  panel.showOrHideAllMarkersBasedOnState();
});

$("#show_operations_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showOperations = !panel.showOperations;
  panel.showOrHideAllMarkersBasedOnState();
});

$("#show_parkings_link").click(function() {
  $(this).toggleClass("active");
  $(this).toggleClass("ui-state-active");
  $(this).toggleClass("ui-state-default");

  panel.showParkings = !panel.showParkings;
  panel.showOrHideAllMarkersBasedOnState();
});
