//
//  UserBlacklistController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/24/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CloudKit

class UserBlacklistController {
    
    //MARK: - Singleton
    static let shared = UserBlacklistController()
    
    //MARK: - Properties
    var blacklist: [String] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Methods
    func fetchBlacklist(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: BlacklistConstants.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let blcklists = records.compactMap({ UserBlacklist(ckRecord: $0) })
            
            self.blacklist = blcklists[0].blacklist
            
            completion(true)
            return
        }
    }
    
    func checkIfBlacklistExists(completion: @escaping (Bool) -> Void) {
        if UserBlacklistController.shared.blacklist.count == 0 {
            completion(false)
            return
        } else {
            completion(true)
            return
        }
    }
    
    func createBlacklist(completion: @escaping (Bool) -> Void) {
        
        let blacklist = UserBlacklist(blacklist: ["default"])
        let blacklistRecord = CKRecord(blacklist: blacklist)
        
        publicDB.save(blacklistRecord) { (_, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
}
