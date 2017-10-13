package com

import java.util.regex.Matcher
import java.util.regex.Pattern
import org.apache.commons.lang.StringEscapeUtils;

class WallMessageFilterTagLib {
	/**
	 * Scripting Injection Prevention
	 */
	def secureMessageText = { attrs, body ->
		def salida=body()
		
		def filteredData=""
		salida.eachLine{
			filteredData+=stripHtml(it) + "<br/>"
		}		
		out << filteredData
	}
	
	def replaceSymbols = { attrs ->
		def text = attrs.value
		def reg = /<symbol>([a-zA-Z\/][^>]*)<\/symbol>/
		def matcher = text =~ reg
		def list = matcher.collect{it[1]}
		def splitted = text.split(reg)
		def result=""
		def symbol
		list.eachWithIndex{ item, i ->
			item = item.toUpperCase()
			symbol = " <a href='${application.getContextPath()}/quotes/"+item+"' class='symbol' onmouseover='loadingGraphic("+'"'+item+'"'+")'><img src='http://static.tradefields.com/symbols/icon/"+item+".ico'> " + item + "</a>"
			result+= (splitted.size()>i?stripHtml(splitted[i])+symbol:symbol)
		}
		if (splitted.size()>list.size()){
			result+=stripHtml(splitted[-1])
		}
		out << result
	}
	
	def stripHtml (text){
		return StringEscapeUtils.escapeHtml(text)
	}
}
