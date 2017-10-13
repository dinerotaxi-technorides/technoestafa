package ar.com.imported

class CloudImage extends CloudFile {
    def cloudFilesService

    Integer width
    Integer height
    ImageSize imageSize

    static belongsTo = [ picture : Picture ]

    static constraints = {
    }
	
    static final Integer MAX_SIZE = 10 * 600 * 400

    def beforeDelete() {
    }
}

enum ImageSize {
    Original([width:0, height:0]),
    Large([width:714, height:402]),
    Medium([width:357, height:201]),
    Small([width:80, height:80]),
    Thumbnail([width:48, height:48])

    final int width
    final int height

    ImageSize(value) {
       this.width = value.width
       this.height = value.height
       }

    int width() { width }
    int height() { height }
    String getKey() { name() }
}    

