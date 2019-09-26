//
//  EventsController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/20/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import CloudKit

class EventController {
    
    //MARK: - Singleton
    static let shared = EventController()
    
    //MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    let eventsWereUpdatedNotification = Notification.Name("eventsWereUpdated")
    var events: [Event] = [] {
        didSet {
            NotificationCenter.default.post(name: eventsWereUpdatedNotification, object: nil)
        }
    }
    
    //MARK: - Methods
    func createEvent(eventTitle: String, eventMatch: String, eventDate: Date, eventTime: Date, eventAddress: String, eventLocation: String, eventDescription: String, locationImage: UIImage?, personsUUID: String, completion: @escaping (Bool) -> Void) {
        
        let event = Event(eventTitle: eventTitle, eventMatch: eventMatch, eventDate: eventDate, eventTime: eventTime, eventAddress: eventAddress, eventLocation: eventLocation, eventDescription: eventDescription, locationImage: locationImage)
        
        event.isAttendingArray.append(personsUUID)
        
        if event.isBlockedBy == [] {
            event.isBlockedBy.append("Default")
        }
        
        let eventRecord = CKRecord(event: event)
        events.append(event)
        
        publicDB.save(eventRecord) { (_, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func updateEventAttendees(event: Event, numberOfAttendees: Int, personsUUIDToAdd: String?, personsUUIDToRemove: String?, completion: @escaping (Bool) -> Void) {
        
        let event = event
        event.totalAttending = numberOfAttendees
        
        if let personsUUIDToAdd = personsUUIDToAdd {
            event.isAttendingArray.append(personsUUIDToAdd)
        } else if let personsUUIDToRemove = personsUUIDToRemove {
            guard let index = event.isAttendingArray.firstIndex(of: personsUUIDToRemove) else { completion(false); return }
            event.isAttendingArray.remove(at: index)
        }
        
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(event: event)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.qualityOfService = .userInteractive
        modificationOP.queuePriority = .veryHigh
        modificationOP.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                print("Error: \(error) \n \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        self.publicDB.add(modificationOP)
    }
    
    func updateEventBlockList(event: Event, personsUUIDToBlock: String?, completion: @escaping (Bool) -> Void) {
        let event = event
        guard let personsUUIDToBlock = personsUUIDToBlock else { completion(false); return }
        event.isBlockedBy.append(personsUUIDToBlock)
        
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(event: event)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.qualityOfService = .userInteractive
        modificationOP.queuePriority = .veryHigh
        modificationOP.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                print("Error: \(error) \n \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        self.publicDB.add(modificationOP)
    }
    
    func fetchAllEvents(completion: @escaping ([Event]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EventConstants.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let records = records else { completion(nil); return }
            
            let events = records.compactMap({ Event(ckRecord: $0) })
            guard let personsUUID = UIDevice.current.identifierForVendor?.uuidString else { return }
            var eventsPlaceholder: [Event] = []
            for event in events {
                if !event.isBlockedBy.contains(personsUUID) {
                    if event.eventDate > Date() {
                        eventsPlaceholder.append(event)
                    }
                }
            }
            
            self.events = eventsPlaceholder
            completion(eventsPlaceholder)
            return
        }
    }
}
