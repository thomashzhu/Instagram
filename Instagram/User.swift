//
//  User.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/11/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class User {
    
    let id: String?
    let username: String?
    let userProfileImageFile: PFFile?
    let postCount: Int?
    let followerCount: Int?
    let favoriteCount: Int?
    
    var isCurrentUser: Bool {
        if let userId = id, let currentUserId = PFUser.current()?.objectId {
            if userId == currentUserId {
                return true
            }
        }
        return false
    }
    
    init(pfObject: PFObject) {
        self.id = pfObject.objectId
        self.username = pfObject["username"] as? String
        self.userProfileImageFile = pfObject["profile_image_file"] as? PFFile
        self.postCount = pfObject["post_count"] as? Int
        self.followerCount = pfObject["follower_count"] as? Int
        self.favoriteCount = pfObject["favorite_count"] as? Int
    }
    
    class func getUserData(userId: String, completion: @escaping (PFObject) -> Void) {
        let query = PFQuery(className: "_User")
        
        query.getObjectInBackground(withId: userId) { userObject, error in
            if let userObject = userObject {
                completion(userObject)
            } else {
                print(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    class func getLocalCurrentUserProfileImage() -> UIImage? {
        if let _ = PFUser.current() {
            let defaults = UserDefaults.standard
            if let localProfileImageData = defaults.data(forKey: "current_profile_image") {
                return UIImage(data: localProfileImageData)
            }
        }
        return nil
    }
    
    class func updateUserImage(userId: String?, image: UIImage?, completion: @escaping PFBooleanResultBlock) {
        if let userId = userId, let image = image {
            let query = PFQuery(className: "_User")
            
            query.getObjectInBackground(withId: userId) { userObject, error in
                if let userObject = userObject {
                    userObject["profile_image_file"] = ParseUtil.getPFFileFromImage(image: image)
                    userObject.saveInBackground(block: completion)
                } else {
                    print(error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }
}
