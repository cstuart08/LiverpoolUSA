//
//  UserBlacklist.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/24/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CloudKit

struct BlacklistConstants {
    static let typeKey = "UserBlacklist"
    static let blacklistKey = "blacklistKey"
}

class UserBlacklist {
    
    let blacklist: [String]
    var recordID: CKRecord.ID
    
    init(blacklist: [String], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.blacklist = blacklist
        self.recordID = recordID
    }
    
    init?(ckRecord: CKRecord) {
        guard let blacklist = ckRecord[BlacklistConstants.blacklistKey] as? [String] else { return nil }
            
            self.blacklist = blacklist
            self.recordID = ckRecord.recordID
        }
    }

    extension CKRecord {
        convenience init(blacklist: UserBlacklist) {
            self.init(recordType: BlacklistConstants.typeKey, recordID: blacklist.recordID)
            setValue(blacklist.blacklist, forKey: BlacklistConstants.blacklistKey)
        }
    }
