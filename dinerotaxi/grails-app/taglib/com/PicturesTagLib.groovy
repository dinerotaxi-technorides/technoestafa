/* Copyright 2011 3BaysOver
 */
package com

class PicturesTagLib {

	static namespace = "pictures"
	
	def each =  { attrs, body ->
		def bean = attrs.bean
		def varName = attrs.var ?: "picture"
		if(bean){
		  if(Picturable.class.isAssignableFrom(bean.class)) {
			  bean.getPictures()?.each {
				  out << body((varName):it)
			  }
		  }
		}
	}
	
	def gallery =  { attrs, body ->
		def bean = attrs.bean
		def varName = attrs.var ?: "picture"
		
		if(bean && Picturable.class.isAssignableFrom(bean.class)) {
          if(bean.getTotalPictures()[0]>0){
            out << g.render(template:"/picture/showGallery", model:[bean:bean])
          }
        }
    }
	
	def edit =  { attrs, body ->
		def bean = attrs.bean
		def varName = attrs.var ?: "picture"
		if(Picturable.class.isAssignableFrom(bean.class)) {
          out << g.render(template:"/picture/showEdit", model:[bean:bean])
        }
    }
    
  def thumbnail =  { attrs, body ->
    def bean = attrs.bean
    def size = attrs.size

    def varName = attrs.var ?: "picture"
    if(Picturable.class.isAssignableFrom(bean.class)) {
        out << "<img src='"+ bean.getThumbnail(ImageSize.Medium)?.url +"' alt=''/>"
      }
    }
}

