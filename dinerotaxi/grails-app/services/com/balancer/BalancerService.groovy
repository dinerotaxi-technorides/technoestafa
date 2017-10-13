package com.balancer
import com.OnlineRadioTaxiComparator
import ar.com.goliath.User;
import ar.com.operation.*;
import java.util.Collections
class BalancerService {

	boolean transactional = true

	def selectRadioTaxi(operation,onlineRadioTaxi){
		def blackLists=operation.blackListRadiotaxiUsers
		List<OnlineRadioTaxi> whiteList=new ArrayList<OnlineRadioTaxi>();
		for(OnlineRadioTaxi rtaxi:onlineRadioTaxi){
			boolean isOnBlackList=false
			if(blackLists){
				for(User u:blackLists){
					if(u.id.equals(rtaxi.company.id) || operation.user.city!=rtaxi.company.city){
						isOnBlackList=true;
					}
				}
				if(!isOnBlackList){
					whiteList.add(rtaxi)
				}
			}else if(operation.user.city==rtaxi.company.city){
				whiteList.add(rtaxi)
			}
		}
		if(!whiteList.isEmpty()){
			Collections.sort(whiteList,new OnlineRadioTaxiComparator());
			OnlineRadioTaxi rtaxiLL=whiteList.get(0)
			if(rtaxiLL.position>0){
				whiteList.each {
					it.position=0L
					it.save(flush:true)
				}
			}
			rtaxiLL.position=1
			rtaxiLL.save(flush:true)
			return rtaxiLL;
		}else{
			return null;
		}
	}
	def selectRadioTaxiForReasign(operation,onlineRadioTaxi,actualCompany){
		def blackLists=operation.blackListRadiotaxiUsers
		List<OnlineRadioTaxi> whiteList=new ArrayList<OnlineRadioTaxi>();
		for(OnlineRadioTaxi rtaxi:onlineRadioTaxi){
			boolean isOnBlackList=false
			if(blackLists){
				for(User u:blackLists){
					if((actualCompany?.id && u.id.equals(actualCompany.id))|| (operation.user.city!=rtaxi.company.city)){
						isOnBlackList=true;
					}
					if(u.id.equals(rtaxi.company.id)){
						isOnBlackList=true;
					}
				}
				if(!isOnBlackList){
					whiteList.add(rtaxi)
				}
			}else if(operation.user.city==rtaxi.company.city){
				whiteList.add(rtaxi)
			}
		}
		if(!whiteList.isEmpty()){
			Collections.sort(whiteList)
			return whiteList.get(0);
		}else{
			return null;
		}
	}
}
