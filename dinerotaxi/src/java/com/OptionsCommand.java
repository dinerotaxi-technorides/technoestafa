package com;

import java.util.Date;

public class OptionsCommand {

	public boolean messaging = false;
	public boolean pet = false;
	public boolean airConditioning = false;
	public boolean smoker = false;
	public boolean specialAssistant = false;
	public boolean luggage = false;
	public OptionsCommand(boolean messaging,boolean pet,boolean airConditioning,boolean smoker,boolean specialAssistant,boolean luggage){
		 this.messaging = messaging;
		 this.pet = pet;
		 this.airConditioning = airConditioning;
		 this.smoker = smoker;
		 this.specialAssistant = specialAssistant;
		 this.luggage = luggage;
	}
	
}
