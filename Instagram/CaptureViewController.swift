//
//  ViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/4/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import PKHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var currentUserProfileImageView: PFImageView!
    @IBOutlet weak var currentUsernameLabel: UILabel!
    
    @IBOutlet weak var imageSelectionView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captureTextField: UITextField!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
        
        picker.delegate = self
        captureTextField.delegate = self
        
        selectedImageView.image = nil
        captureTextField.text = nil
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUserProfileImage),
                                               name: NSNotification.Name(rawValue: "CurrentProfilerImageUpdated"),
                                               object: nil)
        
        view.layoutIfNeeded()
        let radius = currentUserProfileImageView.frame.width / 2
        currentUserProfileImageView.layer.cornerRadius = radius
        currentUserProfileImageView.clipsToBounds = true
        
        updateUserProfileImage()
        
        currentUsernameLabel.text = PFUser.current()?.username
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        // let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.image = editedImage
        imageSelectionView.backgroundColor = .clear
            
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func addImagePressed(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: AnyObject) {
        HUD.show(.progress)
        
        Post.postUserImage(image: selectedImageView.image,
                           withCaption: captureTextField.text,
                           withCompletion: { _ in
                            DispatchQueue.main.async {
                                self.selectedImageView.image = nil
                                self.captureTextField.text = nil
                                HUD.flash(.success)
                            }}
        )
    }
    
    func updateUserProfileImage() {
        if let localUserProfileImage = User.getLocalCurrentUserProfileImage() {
            currentUserProfileImageView.image = localUserProfileImage
        } else if let userId = PFUser.current()?.objectId {
            User.getUserData(userId: userId) { pfObject in
                let user = User(pfObject: pfObject)
                DispatchQueue.main.async {
                    self.currentUserProfileImageView.file = user.userProfileImageFile
                    self.currentUserProfileImageView.loadInBackground()
                }
            }
        }
    }
}

