package com;

import java.util.Date;
import ar.com.operation.OnlineRadioTaxi;
import java.util.Comparator;
public class OnlineRadioTaxiComparator implements Comparator<OnlineRadioTaxi> {
	@Override
	public int compare(OnlineRadioTaxi o1, OnlineRadioTaxi o2) {
		return (o1.getPosition() > o2.getPosition() ? -1 : (o1.getPosition() == o2.getPosition() ? 0 : 1));
	}
}
