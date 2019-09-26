//
//  Event.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/19/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import CloudKit

struct EventConstants {
    static let typeKey = "Event"
    static let titleKey = "titleKey"
    static let matchKey = "matchKey"
    static let dateKey = "dateKey"
    static let timeKey = "timeKey"
    static let addressKey = "addressKey"
    static let locationKey = "locationKey"
    static let descriptionKey = "descriptionKey"
    static let attendingKey = "attendingKey"
    static let isBlockedByKey = "isBlockedByKey"
    static let totalAttendingKey = "totalAttendingKey"
    static let imageKey = "imageKey"
}

class Event {
    var eventTitle: String
    var eventMatch: String
    var eventDate: Date
    var eventTime: Date
    var eventAddress: String
    var eventLocation: String
    var eventDescription: String
    var recordID: CKRecord.ID
    var isAttendingArray: [String]
    var isBlockedBy: [String]
    var totalAttending: Int = 1
    var locationImageData: Data?
    var locationImageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try locationImageData?.write(to: fileURL)
            } catch {
                print("error...")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    var locationImage: UIImage? {
        get {
            guard let data = self.locationImageData else { return nil }
            return UIImage(data: data)
        }
        set {
            locationImageData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(eventTitle: String, eventMatch: String, eventDate: Date, eventTime: Date, eventAddress: String, eventLocation: String, eventDescription: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), isAttendingArray: [String] = [], isBlockedBy: [String] = [], locationImage: UIImage?) {
        self.eventTitle = eventTitle
        self.eventMatch = eventMatch
        self.eventDate = eventDate
        self.eventTime = eventTime
        self.eventAddress = eventAddress
        self.eventLocation = eventLocation
        self.eventDescription = eventDescription
        self.recordID = recordID
        self.isAttendingArray = isAttendingArray
        self.isBlockedBy = isBlockedBy
        self.locationImage = locationImage
    }
    
    init?(ckRecord: CKRecord) {
        guard let imageAsset = ckRecord[EventConstants.imageKey] as? CKAsset,
            let title = ckRecord[EventConstants.titleKey] as? String,
            let match = ckRecord[EventConstants.matchKey] as? String,
            let date = ckRecord[EventConstants.dateKey] as? Date,
            let time = ckRecord[EventConstants.timeKey] as? Date,
            let address = ckRecord[EventConstants.addressKey] as? String,
            let location = ckRecord[EventConstants.locationKey] as? String,
            let attending = ckRecord[EventConstants.attendingKey] as? [String],
            let blockedBy = ckRecord[EventConstants.isBlockedByKey] as? [String],
            let totalAttending = ckRecord[EventConstants.totalAttendingKey] as? Int,
            let description = ckRecord[EventConstants.descriptionKey] as? String else { return nil }
        
        guard let url = imageAsset.fileURL else { return nil }
        
        do {
            self.locationImageData = try Data(contentsOf: url)
        } catch {
            print("error getting image data from imageAsset.fileURL \(error)")
        }
        
        self.eventTitle = title
        self.eventMatch = match
        self.eventDate = date
        self.eventTime = time
        self.eventAddress = address
        self.eventLocation = location
        self.isAttendingArray = attending
        self.isBlockedBy = blockedBy
        self.totalAttending = totalAttending
        self.eventDescription = description
        self.recordID = ckRecord.recordID
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventTitle == rhs.eventTitle && lhs.eventDate == rhs.eventDate && lhs.eventTime == rhs.eventTime && lhs.eventAddress == rhs.eventAddress && lhs.eventLocation == rhs.eventLocation && lhs.eventDescription == rhs.eventDescription
    }
}

extension Event: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if eventTitle.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            return false
        }
    }
}

extension CKRecord {
    convenience init(event: Event) {
        self.init(recordType: EventConstants.typeKey, recordID: event.recordID)
        setValue(event.eventTitle, forKey: EventConstants.titleKey)
        setValue(event.eventMatch, forKey: EventConstants.matchKey)
        setValue(event.eventDate, forKey: EventConstants.dateKey)
        setValue(event.eventTime, forKey: EventConstants.timeKey)
        setValue(event.eventAddress, forKey: EventConstants.addressKey)
        setValue(event.eventLocation, forKey: EventConstants.locationKey)
        setValue(event.isAttendingArray, forKey: EventConstants.attendingKey)
        setValue(event.totalAttending, forKey: EventConstants.totalAttendingKey)
        setValue(event.isBlockedBy, forKey: EventConstants.isBlockedByKey)
        setValue(event.eventDescription, forKey: EventConstants.descriptionKey)
        setValue(event.locationImageAsset, forKey: EventConstants.imageKey)
    }
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventTitle < rhs.eventTitle
    }
}
