//
//  Class.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/9/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    let creationTime: TimeInterval?
    let media: PFFile?
    let authorId: String?
    let caption: String?
    let likesCount: Int?
    let commentsCount: Int?
    
    init(pfObject: PFObject) {
        creationTime = pfObject["creationTime"] as? TimeInterval
        media = pfObject["media"] as? PFFile
        authorId = pfObject["authorId"] as? String
        caption = pfObject["caption"] as? String
        likesCount = pfObject["likesCount"] as? Int
        commentsCount = pfObject["commentsCount"] as? Int
    }
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["creationTime"] = Date.timeIntervalSinceReferenceDate
        post["media"] = ParseUtil.getPFFileFromImage(image: image) // PFFile column type
        post["authorId"] = PFUser.current()?.objectId
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    class func getMostRecentPosts(numberOfPosts: Int, completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "creationTime")
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                completion(posts)
            } else {
                print(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
