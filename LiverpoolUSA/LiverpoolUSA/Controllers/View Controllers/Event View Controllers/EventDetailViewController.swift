//
//  EventDetailViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/20/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import CloudKit
import MessageUI
import MapKit

class EventDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var eventLocationAdressButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var totalAttendingLabel: UILabel!
    @IBOutlet weak var countMeInButton: UIButton!
    @IBOutlet weak var matchHeading: UILabel!
    @IBOutlet weak var whenHeading: UILabel!
    @IBOutlet weak var whereHeading: UILabel!
    @IBOutlet weak var descriptionHeading: UILabel!
    
    //MARK: - Properties
    var eventLandingPad: Event?
    var eventIndex: Int?
    var isAttending: Bool = false
    var totalAttending: Int = 0
    var screenWidth: Int = 0
    let regionInMeters: Double = 10000
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        eventLocationAdressButton.contentHorizontalAlignment = .left
        self.view.backgroundColor = .liverpoolWhite
        screenWidth = Int(self.view.frame.size.width)
        checkAttendingStatus()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    func updateViews() {
        guard let eventLandingPad = eventLandingPad else { return }
        titleLabel.text = eventLandingPad.eventTitle
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: CGFloat(screenWidth / 20))
        matchHeading.font = UIFont(name: matchHeading.font.fontName, size: CGFloat(screenWidth / 20))
        matchLabel.text = eventLandingPad.eventMatch
        matchLabel.font = UIFont(name: matchLabel.font.fontName, size: CGFloat(screenWidth / 20))
        whenHeading.font = UIFont(name: whenHeading.font.fontName, size: CGFloat(screenWidth / 20))
        let formattedEventDate = DateHelper.shared.mediumStringForDate(date: eventLandingPad.eventDate)
        let formattedEventTime = DateHelper.shared.mediumStringForTime(time: eventLandingPad.eventDate)
        dateTimeLabel.font = UIFont(name: dateTimeLabel.font.fontName, size: CGFloat(screenWidth / 20))
        dateTimeLabel.text = "\(formattedEventDate) at \(formattedEventTime)"
        eventImageView.image = eventLandingPad.locationImage
        whereHeading.font = UIFont(name: whereHeading.font.fontName, size: CGFloat(screenWidth / 20))
        locationNameLabel.font = UIFont(name: locationNameLabel.font.fontName, size: CGFloat(screenWidth / 20))
        locationNameLabel.text = eventLandingPad.eventLocation
        eventLocationAdressButton.titleLabel?.font = UIFont(name: "PingFang HK Light", size: CGFloat(screenWidth / 20))
        eventLocationAdressButton.setTitle(eventLandingPad.eventAddress, for: .normal)
        descriptionHeading.font = UIFont(name: descriptionHeading.font.fontName, size: CGFloat(screenWidth / 20))
        //descriptionTextView.font = UIFont(name: "PingFang HK Light", size: CGFloat(screenWidth / 10))
        descriptionTextView.contentOffset.y = 0
        descriptionTextView.text = eventLandingPad.eventDescription
        totalAttending = eventLandingPad.totalAttending
        totalAttendingLabel.text = " Total Attending: \(totalAttending)"
    }
    
    func checkAttendingStatus() {
        guard let deviceUUID = UIDevice.current.identifierForVendor?.uuidString, let event = eventLandingPad else { return }
        if event.isAttendingArray.contains(deviceUUID) {
            isAttending = true
            countMeInButton.setTitle("Count Me Out", for: .normal)
        } else {
            isAttending = false
            countMeInButton.setTitle("Count Me In", for: .normal)
        }
    }
    
    func toggleAttending() {
        if isAttending == false {
            isAttending = true
            countMeInButton.setTitle("Count Me Out", for: .normal)
        } else if isAttending == true {
            isAttending = false
            countMeInButton.setTitle("Count Me In!", for: .normal)
        }
    }
    
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else { return }
        guard let event = eventLandingPad else { return }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["apps@cameronstuart.com"])
        mailComposer.setSubject("Report An Event: \(event.recordID.recordName)")
        mailComposer.setMessageBody("***Please do not make any changes to the subject line. \n \n **Please be aware that once you report this event, it will be pulled from the events list for review. You will no longer have access to this event. If you no longer wish to report this event, please click the 'Cancel' button. \n \n ---Please add any additional information below---", isHTML: false)
        
        present(mailComposer, animated: true)
    }
    
    func presentAlert() {
        if isAttending == true {
            let alertController = UIAlertController(title: "Uh oh!", message: "We couldn't count you out. Are you sure you are logged into an appleID on this device?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Uh oh!", message: "We couldn't count you in. Are you sure you are logged into an appleID on this device?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alertController, animated: true)
        }
    }
    
    //MARK: - Actions
    @IBAction func countMeInButtonTapped(_ sender: Any) {
        guard let personsUUID = UIDevice.current.identifierForVendor?.uuidString else { return }
        if let eventLandingPad = eventLandingPad {
            if isAttending == false {
                totalAttending = eventLandingPad.totalAttending + 1
                EventController.shared.updateEventAttendees(event: eventLandingPad, numberOfAttendees: totalAttending, personsUUIDToAdd: personsUUID, personsUUIDToRemove: nil) { (success) in
                    if success == true {
                        print("Event count update is complete.")
                        self.eventLandingPad?.totalAttending = self.totalAttending
                        DispatchQueue.main.async {
                            self.updateViews()
                            self.toggleAttending()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentAlert()
                        }
                    }
                }
            } else if isAttending == true {
                totalAttending = eventLandingPad.totalAttending - 1
                EventController.shared.updateEventAttendees(event: eventLandingPad, numberOfAttendees: totalAttending, personsUUIDToAdd: nil, personsUUIDToRemove: personsUUID) { (success) in
                    if success == true {
                        print("Event count update is complete.")
                        self.eventLandingPad?.totalAttending = self.totalAttending
                        DispatchQueue.main.async {
                            self.updateViews()
                            self.toggleAttending()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentAlert()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.sendEmail()
        }
    }
    
    @IBAction func locationAddressButtonTapped(_ sender: Any) {
        guard let event = eventLandingPad else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(event.eventAddress) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let mark = MKPlacemark(placemark: placemark)
                
                guard let latitude = placemark.location?.coordinate.latitude else { return }
                guard let longitude = placemark.location?.coordinate.longitude else { return }
                
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let region = MKCoordinateRegion.init(center: center, latitudinalMeters: self.regionInMeters, longitudinalMeters: self.regionInMeters)
                
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
                ]
                
                let mapItem = MKMapItem(placemark: mark)
                
                mapItem.name = "\(event.eventLocation)"
                mapItem.openInMaps(launchOptions: options)
                
            }
        }
    }
}

//MARK: - Extensions
extension EventDetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .saved:
            print("Saved")
        case .sent:
            print("Sent")
        case .failed:
            print("Failed")
        default:
            print("Something else happened.")
        }
        
        controller.dismiss(animated: true) {
            if result == .sent {
                guard let personsUUID = UIDevice.current.identifierForVendor?.uuidString else { return }
                guard let event = self.eventLandingPad else { return }
                EventController.shared.updateEventBlockList(event: event, personsUUIDToBlock: personsUUID) { (success) in
                    print("User has blocked an event.")
                }
                guard let eventIndex = self.eventIndex else { return }
                EventController.shared.events.remove(at: eventIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
