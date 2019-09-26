//
//  EventDescriptionViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/24/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

protocol DescriptionSelectionDelegate {
    func didWriteDescription(description: String)
}

class EventDescriptionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.white.cgColor
        descriptionTextView.becomeFirstResponder()
    }
    
    // MARK: - Properties
    var descriptionDelegate: DescriptionSelectionDelegate!
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let description = descriptionTextView.text else { return }
        descriptionDelegate.didWriteDescription(description: description)
        self.dismiss(animated: true) {
        }
    }
}
