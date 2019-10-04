//
//  NoNetworkViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 10/3/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit



class NoNetworkViewController: UIViewController {
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func okayButtonTapped(_ sender: Any) {
        let notification = Notification(name: Notification.Name(rawValue: "dismissLoadingView"))
        NotificationCenter.default.post(notification)
        self.dismiss(animated: true)
    }
}
