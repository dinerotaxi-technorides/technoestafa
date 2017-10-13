package es.osoco.android.gcm

import ar.com.goliath.User

import com.Device
import com.UserDevice
import com.google.android.gcm.server.Message
import com.google.android.gcm.server.MulticastResult
import com.google.android.gcm.server.Sender

class DeviceController {

	def subscribe = {
		if (params.deviceToken && !Device.findByKeyValue(params.deviceToken)) {
			def usr=User.findByUsername("rrhh@technorides.com")
			new Device(keyValue:params.deviceToken,description:"     ",dev:UserDevice.ANDROID,user:usr).save(failOnError:true)
		}


		Sender sender = new Sender("AIzaSyCZTGEDGyM5chN4RNCs7fPAmoj1fO8IO4U");
		Message message = new Message.Builder().build();
		MulticastResult result = sender.send(message, params.deviceToken, 5);
		render ""
	}
}
