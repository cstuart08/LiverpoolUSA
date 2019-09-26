//
//  NavigationBarController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/18/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class NavigationBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
}
