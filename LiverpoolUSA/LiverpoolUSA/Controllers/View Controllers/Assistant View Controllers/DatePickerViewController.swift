//
//  DatePickerViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/21/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

protocol DateSelectionDelegate {
    func didSelectDate(date: Date)
}

class DatePickerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.tintColor = .white
        datePicker.minimumDate = Date()
    }
    
    // MARK: - Properties
    var dateDelegate: DateSelectionDelegate!
    var eventDate = Date()
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        eventDate = datePicker.date
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dateDelegate.didSelectDate(date: eventDate)
        self.dismiss(animated: true) {
        }
    }
}
