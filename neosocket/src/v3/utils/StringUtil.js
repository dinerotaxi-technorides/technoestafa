'use strict';


module.exports.isBlank = function (value){

    var blank=false;
    if (!value || value === "") blank=true;
    return blank;
};