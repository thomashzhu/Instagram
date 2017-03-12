//
//  ClickablePFImageView.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/11/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import ParseUI

class ClickablePFImageView: PFImageView, UIGestureRecognizerDelegate {

    var userId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentProfileVC))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
        
        self.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = self.bounds.width / 2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func presentProfileVC() {
        if let userId = userId {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                    if let navigationControllerVC = tabBarController.selectedViewController as? UINavigationController {
                        vc.userId = userId
                        navigationControllerVC.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
