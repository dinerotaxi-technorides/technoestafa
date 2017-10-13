package ar.com.imported
import ar.com.goliath.*
class Picture implements Comparable {
    String filename
    String caption = ""
    String contentType
    Integer width
    Integer height
    Date dateCreated = new Date()
    Date lastUpdated = new Date()

    static hasMany = [ images : CloudImage, links : PictureLink ]
    
    static belongsTo = [ User ] 

    static constraints = {
        caption(size: 0..40)
    }

    static mapping = {
        images cascade: 'all-delete-orphan', inverse: true
        links cascade: 'all-delete-orphan', inverse: true
        user index: 'pictures_user_index', unique: false
    }
    
    static transients = ['thumbnail','large','medium','small']

    int compareTo(obj) {
        obj.id.compareTo(id)
    }
    
    CloudImage getImage(ImageSize size){
        def result
        images.each{
          if(it.imageSize == size){
            result = it
          }
        }
        return result
    }
    
    CloudImage getThumbnail(){
        return getImage(ImageSize.Thumbnail)
    }
    def setThumbnail(CloudImage image){
    }
    CloudImage getSmall(){
        return getImage(ImageSize.Small)
    }
    def setSmall(CloudImage image){
    }
    CloudImage getLarge(){
        return getImage(ImageSize.Large)
    }
    def setLarge(CloudImage image){
    }
    CloudImage getMedium(){
        return getImage(ImageSize.Medium)
    }
    def setMedium(CloudImage image){
    }
}

