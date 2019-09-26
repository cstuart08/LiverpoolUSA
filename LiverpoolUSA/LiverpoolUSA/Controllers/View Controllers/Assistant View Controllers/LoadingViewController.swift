//
//  LoadingViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/18/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var liverpoolLabel: UILabel!
    
    //MARK: - Properties
    var currentTime: Float = 0.0
    var maxTime: Float = 10.0
    var fromTabOne: Bool = false
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProgress()
        let notification = Notification.Name(rawValue: "dismissLoadingView")
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: notification, object: nil)
    }
    
    //MARK: - Methods
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadProgress() {
        progressView.setProgress(currentTime, animated: true)
        perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
    }
    
    @objc func updateProgress() {
        currentTime = currentTime + 1.0
        progressView.progress = currentTime/maxTime
        
        if currentTime < maxTime - 1.0 {
            perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
        }
    }
}
