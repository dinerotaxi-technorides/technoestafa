'use strict';

const device  = require('../utils/device');

class DeviceService {

    constructor(device_dao) {
        this._device = device_dao;
    }

    /*
     @parameters:
     user_id
     */
    findAllByUserId(user_id) {
        var device;
        if (!user_id) device = this._device.findAllByUserId(user_id);
        return device;
    }

    /*
     @parameters:
     user_id
     */
    deleteAllByUserId(user_id) {
        var result = false;
        if (!user_id) result = this._device.deleteAllByUserId(user_id);
        return result;
    }

    /*
     @parameters:
     device
     keyValue
     usr_id
     */
    setDeviceToUser(device, keyValue, user_id) {
        return this._device.insert({
            keyValue: keyValue != null ? keyValue : 'WEB',
            description: " ",
            dev: device != null ? device : device.WEB,
            user_id: user_id
        });
    }
}

module.exports = DeviceService;