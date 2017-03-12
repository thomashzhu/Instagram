//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/11/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import ParseUI
import PKHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: PFImageView!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet var profileImageTapRecognizer: UITapGestureRecognizer!
    
    var userId: String! = PFUser.current()?.objectId
    let picker = UIImagePickerController()
    
    private var presentingUserId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // Only show the close button if view controller is pushed modally
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
           let _ = tabBarController.selectedViewController as? UINavigationController {
            closeButton.isHidden = true
            logoutButton.isHidden = true
        } else {
            closeButton.isHidden = false
            logoutButton.isHidden = false
        }
        
        // Apply blur effect to background
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundImageView.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.backgroundImageView.addSubview(blurEffectView)
        }
        
        // Round corner effect of the profile image view
        view.layoutIfNeeded()
        let radius = profileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = radius
        profileImageView.clipsToBounds = true
        
        // Only enable if presenting profile is of current user's
        profileImageView.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if presentingUserId == nil || presentingUserId != userId {
            User.getUserData(userId: userId) { pfObject in
                let user = User(pfObject: pfObject)
                DispatchQueue.main.async {
                    self.configureUI(user: user)
                }
            }
            
            presentingUserId = userId
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        PFUser.logOutInBackground { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }
    
    @IBAction func profileImageViewTapped(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        present(vc, animated: true, completion: nil)
    }
    
    private func configureUI(user: User) {
        
        if let userProfileImageFile = user.userProfileImageFile {
            closeButton.setImage(UIImage(named: "close_white"), for: .normal)
            logoutButton.setImage(UIImage(named: "log_out_white"), for: .normal)
            
            backgroundImageView.file = userProfileImageFile
            backgroundImageView.loadInBackground()
            
            profileImageView.file = userProfileImageFile
            profileImageView.loadInBackground()
        }
        
        // Enable change profile image tap recognizer if it's current user
        if user.isCurrentUser {
            profileImageView.isUserInteractionEnabled = true
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        backgroundImageView.image = editedImage
        profileImageView.image = editedImage
        
        User.updateUserImage(userId: userId, image: editedImage) { (success, error) in
            if success {
                let defaults = UserDefaults.standard
                defaults.set(UIImagePNGRepresentation(editedImage), forKey: "current_profile_image")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentProfilerImageUpdated"), object: nil)
                HUD.hide(animated: true)
            } else {
                print(error?.localizedDescription ?? "Unknown error")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
