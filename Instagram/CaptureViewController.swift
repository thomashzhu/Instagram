//
//  ViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/4/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import PKHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageSelectionView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captureLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
        
        picker.delegate = self
        
        selectedImageView.image = nil
        captureLabel.text = nil
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
                           withCaption: captureLabel.text,
                           withCompletion: { _ in
                            DispatchQueue.main.async {
                                self.selectedImageView.image = nil
                                self.captureLabel.text = nil
                                HUD.flash(.success)
                            }}
        )
    }
}

