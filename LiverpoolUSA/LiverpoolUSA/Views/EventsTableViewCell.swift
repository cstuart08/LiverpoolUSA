//
//  EventsTableViewCell.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/20/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    
    // MARK: - Properties
    var event: Event? {
        didSet {
            eventImageView.image = nil
            guard let event = event else { return }
            DispatchQueue.main.async {
                self.eventImageView.image = event.locationImage
                self.titleLabel.text = event.eventTitle
                self.matchLabel.text = event.eventMatch
                let formattedEventTime = DateHelper.shared.mediumStringForTime(time: event.eventDate)
                let formattedEventDate = DateHelper.shared.mediumStringForDate(date: event.eventDate)
                self.dateTimeLabel.text = "\(formattedEventDate) at \(formattedEventTime)"
                self.cityStateLabel.text = event.eventAddress
            }
        }
    }
}
