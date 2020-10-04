//
//  LaunchScreenViewController.swift
//  LiverpoolUSA
//
//  Created by Cameron Stuart on 10/3/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var redsLabel: UILabel!
    @IBOutlet weak var usaLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barView.alpha = 0.0
        addBarView()
    }
    
    func runOpeningRedsAnimation() {
        UIView.animate(withDuration: 0.7) {
            self.redsLabel.transform = CGAffineTransform(translationX: -500, y: 0)
        } completion: { (_) in
            self.runOpeningUsaAnimation()
        }
    }
    
    func runOpeningRedsAnimation2() {
        UIView.animate(withDuration: 0.7) {
            self.redsLabel.transform = CGAffineTransform(translationX: -900, y: 0)
        }
    }
    
    func addBarView() {
        UIView.animate(withDuration: 0.7) {
            self.barView.alpha = 1.0
        } completion: { (_) in
            self.runOpeningRedsAnimation()
        }
    }
    
    func removeBarView() {
        UIView.animate(withDuration: 0.7) {
            self.barView.alpha = 0.0
        }
    }
    
    func runOpeningUsaAnimation() {
        UIView.animate(withDuration: 0.7) {
            self.usaLabel.transform = CGAffineTransform(translationX: 500, y: 0)
        } completion: { (_) in
            sleep(2)
            self.runOpeningUsaAnimation2()
            self.runOpeningRedsAnimation2()
            self.removeBarView()
        }
    }
    
    func runOpeningUsaAnimation2() {
        UIView.animate(withDuration: 0.7) {
            self.usaLabel.transform = CGAffineTransform(translationX: 900, y: 0)
        } completion: { (_) in
            guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .overFullScreen
            self.definesPresentationContext = true
            self.present(viewController, animated: true)
        }
    }
}
