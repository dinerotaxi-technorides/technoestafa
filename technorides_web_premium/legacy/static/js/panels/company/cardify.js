// Plugin
$.fn.cardify = function(config) {
  config["div"] = $(this);
  this.addClass("cardify_container");

  // Cardify
  this.data("cardify", new Cardify(config));
}

// Cardify
function Cardify(config) {
  // Config
  this.div               = config["div"];
  this.url               = config["url"];
  this.editUrl           = config["edit_url"];
  this.fields            = config["fields"];
  this.rows              = config["rows"];
  this.imageUrl          = config["imageUrl"];
  this.imageFieldIndex   = config["imageFieldIndex"];
  this.defaultImage      = config["defaultImage"];
  this.maxPageDifference = config["maxPageDifference"];

  this.cache             = {};

  this.page              = 1;
  this.totalPages        = 0;

  this.query             = "";

  this.done              = config["done"];
  this.fail              = config["fail"];

  // Get Page
  this.getPage = function(page, query) {
    that = this;
    // Get
    $.ajax(
      {
        url: this.url,
        dataType: "json",
        data: {
          page: page,
          rows: that.rows,
          searchField: "username",
          searchString: query,
          searchOper: "eq"
        },
        success: function(data) {
          that.div.html("");

          // Cache
          that.cache = {};

          // Rows
          $.each(
            data.rows,
            function(rowIndex, rowItem) {
              // Cache
              that.cache[rowItem.id] = {};
              // ul
              that.div.append("<div class='cardify' rel='" + rowItem.id + "'><div class='cardify_image_container'><img class='cardify_image' rel='" + rowItem.id + "' " + that.fields[that.imageFieldIndex]["name"] + "='" + rowItem.cell[that.imageFieldIndex] + "' src='" + that.imageUrl + "?" + that.fields[that.imageFieldIndex]["name"] + "=" + rowItem.cell[that.imageFieldIndex] + "&hola=" + parseInt(new Date().getTime()) + "' onerror=\"this.src='" + that.defaultImage + "';\"><img src='/static/images/panels/company/cardify/edit.png' class='cardify_image_edit'></div><ul class='cardify_row cardify_row_" + rowIndex + "'></ul><button class='cardify_edit' rel='" + rowItem.id + "'/><button class='cardify_show_1' rel='" + rowItem.id + "'/><button class='cardify_show' rel='" + rowItem.id + "'/><button class='cardify_destroy' rel='" + rowItem.id + "'/></div>");
              // Cells
              $.each(
                rowItem.cell,
                function(cellIndex, cellItem) {
                  that.cache[rowItem.id][that.fields[cellIndex]["name"]] = cellItem;
                  if(!that.fields[cellIndex]["hide"]) {
                    if(that.fields[cellIndex]["regexp"]) {
                      cellItem = cellItem.replace(that.fields[cellIndex]["regexp"], "");
                    }
                    cellItem = cellItem.toLowerCase();
                    if(cellItem.length > 8) {
                      cellItem = cellItem.substring(0, 5) + "...";
                    }
                    // li
                    that.div.find(".cardify_row_" + rowIndex).append("<li class='cardify_cell cardify_cell_" + that.fields[cellIndex]["name"] + "'><span class='cardify_title'>" + that.fields[cellIndex]["title"] + "</span>: " + cellItem + "</li>")
                  }
                }
              );
            }
          );

          // Paginator
          that.page       = page;
          that.query      = query;
          that.totalPages = parseInt(data.total);

          if(that.totalPages > 1) {
            that.div.append("<div class='cardify_paginator' rel='" + that.div.attr("id") + "'></div>");
            that.div.find(".cardify_paginator").html("");
            if(that.page > (that.maxPageDifference + 1)) {
              that.div.find(".cardify_paginator").append("...&nbsp;");
            }
            for(var index = (that.page > that.maxPageDifference + 1 ? (that.page - that.maxPageDifference) : 1); index <= that.totalPages && index <= (that.page + that.maxPageDifference); index++) {
              that.div.find(".cardify_paginator").append("<button class='cardify_paginator_link' rel='" + index + "' data='" + query + "'>" + index + "</button>&nbsp;");
            }
            if((that.totalPages - that.page) > that.maxPageDifference) {
              that.div.find(".cardify_paginator").append("...&nbsp;");
            }
            that.div.find(".cardify_paginator").find(".cardify_paginator_link[rel=" + that.page + "]").addClass("current");
          }
        }
      }
    ).done(
      function() {
        // Done()
        if(Object.prototype.toString.call(that.done) == "[object Function]") {
          that.done();
        }
      }
    ).fail(
      function() {
        // Fail()
        if(Object.prototype.toString.call(that.fail) == "[object Function]") {
          that.fail();
        }
      }
    );
  }

  // Get first page
  this.getPage(this.page, "");
}

// Click
$(document).on("click", ".cardify_paginator_link",
  function() {
    $("#" + $(this).parent().attr("rel")).data("cardify").getPage(parseInt($(this).attr("rel")), $(this).attr("data"));
    return(false);
  }
);
