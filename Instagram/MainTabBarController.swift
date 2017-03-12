//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/9/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeGreen = UIColor(red: 80/255,
                                 green: 229/255,
                                 blue: 162/255,
                                 alpha: 1)
        tabBar.barTintColor = themeGreen
        tabBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
