//
//  LoginTextField.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/11/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius = self.bounds.height / 2
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
