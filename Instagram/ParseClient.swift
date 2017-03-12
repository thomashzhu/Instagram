//
//  InstagramClient.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/9/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class ParseUtil {
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            if let resizedImage = resize(image: image, newScale: 0.5) {
                // get image data and check if that is not nil
                if let imageData = UIImagePNGRepresentation(resizedImage) {
                    return PFFile(name: "image.png", data: imageData)
                }
            }
        }
        return nil
    }
    
    class func resize(image: UIImage, newScale: CGFloat) -> UIImage? {
        let size = image.size
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width * newScale, height: size.height * newScale))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
