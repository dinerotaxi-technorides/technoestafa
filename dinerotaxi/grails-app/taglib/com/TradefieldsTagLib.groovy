package com
import java.text.NumberFormat;
import java.text.DecimalFormat;
import javax.swing.text.html.HTML

import org.apache.commons.lang.StringEscapeUtils;

class TradefieldsTagLib {
	def baseURL={
		out << ("http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath())
	}
	
	def number = {attrs->
		def default_value = "-"
		def res
		
		if (attrs.value!=null){
			try{
				def format = attrs.format
				def letters = attrs.letters
				def dollar = attrs.dollar
				def percent = attrs.percent
				def color = attrs.color
				def parenthesis = attrs.parenthesis
				def absolute = attrs.absolute?attrs.absolute.equalsIgnoreCase("true"):false
				
				NumberFormat formatter = new DecimalFormat(format!=null?format:"0.00");
				def value = new Double(attrs.value)
				
				if(letters && letters.equalsIgnoreCase("true")){
					switch(value){
						case { it.abs() >= 1000000000 }:
							res= formatter.format(((absolute?value.abs():value)/1000000000).trunc(2)) + "B";
							break;
						case { it.abs() >= 1000000 && it.abs() <1000000000}:
							res= formatter.format(((absolute?value.abs():value)/1000000).trunc(2)) + "M";
							break;
						case { it.abs() >= 1000 && it.abs() <1000000}:
							res= formatter.format(((absolute?value.abs():value)/1000).trunc(2)) + "K";
							break;
						case { it.abs() >= 1 && it.abs() <1000}:
							res= formatter.format((absolute?value.abs():value).trunc(2));
							break;
						default:
							formatter = new DecimalFormat(format!=null?format:"0.00##");
							res= formatter.format((absolute?value.abs():value));
							break;
					}
				}else{
					if (value.abs()<1){
						formatter = new DecimalFormat(format!=null?format:"0.00##");
					}else{
						formatter = new DecimalFormat(format!=null?format:",###.00");
					}
					
					res= formatter.format((absolute?value.abs():value));
				}
				
				if (dollar && dollar.equalsIgnoreCase("true")){
					res="\$$res"
				}
				
				if (percent && percent.equalsIgnoreCase("true")){
					res+="%"
				}
				
				if (parenthesis && parenthesis.equalsIgnoreCase("true")){
					res="($res)"
				}
				
				if (color && color.equalsIgnoreCase("true")){
					if (value>0){
						res= "<span class=pos>$res</span>"
					}else if (value<0){
						res= "<span class=neg>$res</span>"
					}
				}
			}catch (Exception e){
				res = ""
			}
		}else{
			res = default_value
		}
		out << res
	}
	
	def capitalize = {attrs->
		out <<attrs.value.split(' ').collect{it.capitalize()}.join(' ')
	}
	
	def googlePlus = {
		out << "<g:plusone size='medium'></g:plusone>"
	}
	
	def stripHtml = {attrs->
		out << StringEscapeUtils.escapeHtml(attrs.value)
	}
	
	def createUrl = { attrs->
		out << servletContext.getContextPath() + (params.baseUrl?'/'+params.baseUrl:'') + (attrs.value?:'')
	}
	
	def isFacebook = {
		out << ((params.baseUrl=='fb')?'true':'false')
	}
}
