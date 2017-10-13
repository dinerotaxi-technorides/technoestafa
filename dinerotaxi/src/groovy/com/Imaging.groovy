package com

import java.awt.AlphaComposite
import java.awt.Color
import java.awt.Graphics2D
import java.awt.geom.AffineTransform
import java.awt.geom.Rectangle2D
import java.awt.image.AffineTransformOp
import java.awt.image.BufferedImage
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import javax.imageio.ImageIO
import ar.com.goliath.User
import ar.com.imported.*
class Imaging {
//
//    static def createAll(User user, Picture picture, InputStream stream) {
//        BufferedImage original = ImageIO.read(stream)
//        picture.contentType = 'image/jpeg'
//        picture.width = original.width
//        picture.height = original.height
//        def images = [ 
//            new CloudImage(user: user, picture: picture, size: CloudImage.Original),
//            new CloudImage(user: user, picture: picture, size: CloudImage.Large),
//            new CloudImage(user: user, picture: picture, size: CloudImage.Medium),
//            new CloudImage(user: user, picture: picture, size: CloudImage.Small) 
//            ]
//        ByteArrayOutputStream output = new ByteArrayOutputStream(1024 * 1024)
//        updateImages(images, original, output)
//        images
//    }
//
//    static def createImage(User user, Picture picture, InputStream stream) {
//        def img = new CloudImage(user: user, picture: picture, size: CloudImage.Large)
//        ByteArrayOutputStream output = new ByteArrayOutputStream(1024 * 1024)
//        
//        BufferedImage thumbnail = Thumbnails
//        .of(stream)
//        .size(CloudImage.size.large.width, CloudImage.size.large.height)
//        .outputFormat("jpg")
//        .asBufferedImage()
//        
//        
//        ImageIO.write( thumbnail, "jpg", output );
//        output.flush();
//        img.data = output.toByteArray();
//        output.close();
//        
//        /*		
//         BufferedImage thumbnail1 = Thumbnails
//        .of(stream)
//        .size(Image.Widths[Image.Large], Image.Heights[Image.Large])
//        .outputFormat("png")
//        .toOutputStream(output); 
//        img.data = output.toByteArray() 
//         */
//        img.contentType = "image/jpg"
//        img.width = thumbnail.width
//        img.height = thumbnail.height
//        picture.contentType = 'image/jpg'
//        picture.width = thumbnail.width
//        picture.height = thumbnail.height
//        img
//    }
//	
//	static def cropImage(Picture picture, CloudImage image, int x, int y, int w, int h) {
//		ByteArrayOutputStream output = new ByteArrayOutputStream(1024 * 1024)
//		
//    BufferedImage original = ImageIO.read(new ByteArrayInputStream(image.data))
//		// From a BufferedImage
//		BufferedImage cropped = original.getSubimage(x, y, w, h);
//		
//		ImageIO.write( cropped, "png", output );
//		output.flush();
//		image.data = output.toByteArray();
//		output.close();
//		
//		image.width = w
//		image.height = h
//		picture.width = w
//		picture.height = h
//		image
//	}
//	
//	static def Thumbnail(CloudImage image, int size) {
//		def thumb = new CloudImage()
//		def width = image.width
//		def height = image.height
//		
//		ByteArrayOutputStream output = new ByteArrayOutputStream(1024 * 1024)
//		
//		if(size != CloudImage.Original) {
//			width = CloudImage.size[size].width
//			height = CloudImage.size[size].height
//		}
//		
//		
//		BufferedImage original = ImageIO.read(new ByteArrayInputStream(image.data))
//		BufferedImage thumbnail = Thumbnails
//			.of(original)
//			.size(width, height)
//			.outputFormat("jpg")
//			.toOutputStream(output);
//
//		//ImageIO.write( thumbnail, "jpg", output );
//		output.flush();
//		thumb.data = output.toByteArray();
//		output.close();
//		thumb
//	}
//
//	private static def updateImages(images, original, stream) {
//		updateImage(images[0], original, 'jpeg', stream)
//		def large = resizeImage(original, dimensions(CloudImage.Large), false)
//		updateImage(images[1], large, 'png', stream)
//		updateImage(images[2], resizeImage(large, dimensions(CloudImage.Medium), true), 'png', stream)
//		updateImage(images[3], resizeImage(large, dimensions(CloudImage.Small), true), 'png', stream)
//	}
//
//	private static def updateImage(image, data, format, stream) {
//		image.contentType = "image/${format}"
//		image.width = data.width
//		image.height = data.height
//		stream.reset()
//		if (!ImageIO.write(data, format, stream)) {
//			throw new IOException("Can't write the image in the given format '${format}'")
//		}
//		image.data = stream.toByteArray()
//	}
//
//    static def updateAll(Picture picture) {
//        def operation = picture.operation
//        if (operation == Picture.NoOp) {
//            return null
//        }
//        def images = picture.images.toArray() // Image.findAllByPicture(picture, [ sort: 'size', order: 'asc' ])
//        BufferedImage original = ImageIO.read(new ByteArrayInputStream(images[0].data))
//        AffineTransform transform = new AffineTransform();
//        def op = null
//        boolean paint = false
//        Integer width = original.width
//        Integer height = original.height
//        switch (operation) {
//            case Picture.RotateClockWise90:
//                transform.rotate(Math.PI / 2.0)
//                transform.translate(0, -height)
//                op = new AffineTransformOp(transform, AffineTransformOp.TYPE_BILINEAR);
//                width = original.height
//                height = original.width
//                paint = true
//                break
//            case Picture.RotateAntiClockWise90:
//                transform.rotate(-Math.PI / 2.0)
//                transform.translate(-width, 0)
//                op = new AffineTransformOp(transform, AffineTransformOp.TYPE_BILINEAR);
//                width = original.height
//                height = original.width
//                paint = true
//                break
//            case Picture.Rotate180:
//                transform.rotate(Math.PI)
//                transform.translate(-width, -height)
//                op = new AffineTransformOp(transform, AffineTransformOp.TYPE_BILINEAR);
//                break
//            case Picture.Flip: // vertical
//                transform.scale(-1.0d, 1.0d)
//                transform.translate(-width, 0)
//                op = new AffineTransformOp(transform, AffineTransformOp.TYPE_NEAREST_NEIGHBOR)
//                break
//            case Picture.Flop: // horizontal
//                transform.scale(1.0d, -1.0d)
//                transform.translate(0, -height)
//                op = new AffineTransformOp(transform, AffineTransformOp.TYPE_NEAREST_NEIGHBOR)
//                break
//            default:
//                return images
//                break
//        }
//        BufferedImage modified = op.filter(original, null);
//        if (paint) {
//            BufferedImage changed = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
//            Graphics2D graphics = changed.createGraphics()
//            graphics.drawImage(modified, 0, 0, width, height, null)
//            graphics.dispose()
//            modified = changed
//            picture.width = width
//            picture.height = height
//        }
//        ByteArrayOutputStream output = new ByteArrayOutputStream(1024 * 1024)
//        updateImages(images, modified, output)
//        images
//    }
//
//
//    private static def dimensions(size) {
//        [ CloudImage.size[size].width, CloudImage.size[size].height ]
//    }    
//
//    private static def resizeImage(imageBuffer, dims, fit) {
//        Integer width = dims[0]
//        Integer height = dims[1]
//        Integer imageWidth = imageBuffer.width
//        Integer imageHeight = imageBuffer.height
//      
//        Double widthScale = (double)width / (double)imageWidth
//        Double heightScale = (double)height / (double)imageHeight
//        BufferedImage resizedImage = imageBuffer
//        if (widthScale < 1.0d || heightScale < 1.0d) {
//            Double scale = Math.min(widthScale, heightScale)
//            def transform = new AffineTransform()
//            transform.scale(scale, scale)
//            def op = new AffineTransformOp(transform, AffineTransformOp.TYPE_BILINEAR)
//            resizedImage = op.filter(imageBuffer, null)
//            imageWidth = resizedImage.width
//            imageHeight = resizedImage.height
//        }
//
//        if (fit && (imageWidth < width || imageHeight < height)) {
//            BufferedImage fittedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB)
//            Integer left = (width - imageWidth) / 2
//            Integer top = (height - imageHeight) / 2
//            Graphics2D graphics = fittedImage.createGraphics()
//            graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.CLEAR, 0.0f))
//            graphics.fill(new Rectangle2D.Double(0, 0, width, height))
//            graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f))
//            graphics.drawImage(resizedImage, left, top, imageWidth, imageHeight, null)
//            graphics.dispose()
//            return fittedImage
//        }
//        resizedImage
//    }
}
