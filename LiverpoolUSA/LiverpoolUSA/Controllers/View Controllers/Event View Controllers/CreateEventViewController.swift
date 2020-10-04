//
//  CreateEventViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/21/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var matchTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addADescriptionButton: UIButton!
    @IBOutlet weak var pickDateButton: UIButton!
    @IBOutlet weak var pickLocationButton: UIButton!
    @IBOutlet var viewFrame: UIView!
    
    // MARK: - Properties
    var isBanned: Bool = false
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapResign))
        view.addGestureRecognizer(tap)
        descriptionTextView.text = "Click 'Add A Description' to add a description of your event."
        addADescriptionButton.backgroundColor = .liverpoolWhite
        pickDateButton.backgroundColor = .liverpoolWhite
        pickLocationButton.backgroundColor = .liverpoolWhite
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Enter event title here... (ex. Liverpool Fans Unite!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        matchTextField.attributedPlaceholder = NSAttributedString(string: "Enter match here... (ex. Liverpool vs Chelsea)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        UserBlacklistController.shared.checkIfBlacklistExists { (success) in
            if success {
                guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else { return }
                if UserBlacklistController.shared.blacklist.contains(deviceID) {
                    self.isBanned = true
                } else {
                    self.isBanned = false
                }
            } else {
                print("Failed to find blacklist.")
                UserBlacklistController.shared.createBlacklist { (success) in
                    print("Blacklist created.")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // Mark: - Properties
    var eventDate = Date()
    var eventLocationName = ""
    var eventLocationAddress = ""
    var randomImages: [UIImage] = [UIImage(named: "liverpoolPlayer1") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer2") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer3") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer4") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer5") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer6") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer7") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer8") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer9") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer10") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer11") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer12") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer13") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer14") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer15") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer16") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer17") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer18") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer19") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer20") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer21") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer22") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer23") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer24") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer25") ?? #imageLiteral(resourceName: "Liverpool"), UIImage(named: "liverpoolPlayer26") ?? #imageLiteral(resourceName: "Liverpool")]
    
    //MARK: - Methods
    @objc func tapResign() {
        titleTextField.resignFirstResponder()
        matchTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Uh oh!", message: "We couldn't create your event. Are you sure you are logged into an appleID on this device?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertController, animated: true)
    }
    
    func missingFieldAlert() {
        let alertController = UIAlertController(title: "Uh oh!", message: "Please make sure all the fields are filled out.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func addADescriptionButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        matchTextField.resignFirstResponder()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDescriptionSB") as! EventDescriptionViewController
        viewController.descriptionDelegate = self
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.93)
        viewController.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        self.present(viewController, animated: true)
    }
    
    @IBAction func pickDateButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        matchTextField.resignFirstResponder()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datePickerSB") as! DatePickerViewController
        viewController.dateDelegate = self
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.93)
        viewController.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        self.present(viewController, animated: true)
    }
    
    @IBAction func selectLocationButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        matchTextField.resignFirstResponder()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "placeFinderSB") as! PlacesSearchViewController
        viewController.placeDelegate = self
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.93)
        viewController.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        self.present(viewController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let personsUUID = UIDevice.current.identifierForVendor?.uuidString else { return }
        if isBanned == true {
            return
        } else {
            if titleTextField.text != "" && matchTextField.text != "" && descriptionTextView.text != "" && eventLocationName != "" && eventLocationAddress != "" && descriptionTextView.text != "Click 'Add A Description' to add a description of your event." {
                guard let eventTitle = titleTextField.text, let eventMatch = matchTextField.text, let eventDescription = descriptionTextView.text else { return }
                EventController.shared.createEvent(eventTitle: eventTitle, eventMatch: eventMatch, eventDate: eventDate, eventTime: eventDate, eventAddress: eventLocationAddress, eventLocation: eventLocationName, eventDescription: eventDescription, locationImage: randomImages.randomElement(), personsUUID: personsUUID) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentAlert()
                        }
                    }
                }
            } else {
                missingFieldAlert()
            }
        }
    }
}

//MARK: - Extensions
extension CreateEventViewController: DateSelectionDelegate {
    func didSelectDate(date: Date) {
        eventDate = date
        let dateSTR = DateHelper.shared.mediumStringForDateAndTime(date: date)
        pickDateButton.setTitle(dateSTR, for: .normal)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension CreateEventViewController: PlaceSelectionDelegate {
    func didSelectPlace(place: Place) {
        eventLocationName = place.name
        eventLocationAddress = place.address
        pickLocationButton.setTitle(place.name, for: .normal)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension CreateEventViewController: DescriptionSelectionDelegate {
    func didWriteDescription(description: String) {
        descriptionTextView.text = description
        addADescriptionButton.setTitle("--change description--", for: .normal)
    }
}
