//
//  ESTabBarItemProtocol.swift
//
//  Created by egg swift on 16/4/7.
//  Copyright (c) 2013-2016 ESPullToRefresh (https://github.com/eggswift/ESTabBarController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

public protocol ESTabBarItemAnimatorProtocol {
    
    mutating func selectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?)
    
    mutating func deselectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?)
    
    mutating func reselectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?)
    
    mutating func highlightAnimation(content content: UIView, animated: Bool, completion: (() -> ())?)
    
    mutating func dehighlightAnimation(content content: UIView, animated: Bool, completion: (() -> ())?)
    
}

extension ESTabBarItemAnimatorProtocol {
    
    public func selectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?) {
        // DO NOTHING...
    }
    
    public func reselectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?) {
        // DO NOTHING...
    }
    
    public func deselectAnimation(content content: UIView, animated: Bool, completion: (() -> ())?) {
        // DO NOTHING...
    }
    
    func highlightAnimation(content content: UIView, animated: Bool, completion: (() -> ())?) {
        // DO NOTHING...
    }
    
    func dehighlightAnimation(content content: UIView, animated: Bool, completion: (() -> ())?) {
        // DO NOTHING...
    }

}
