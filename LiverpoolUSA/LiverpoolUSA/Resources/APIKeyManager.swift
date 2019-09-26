//
//  APIKeyManager.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/26/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

class APIKeyManager {
    
    static func retrieveAPIKey(name: String) -> String {
        guard let filepath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else { print("APIKey.plist not found."); return "error" }
        let propertyList = NSDictionary.init(contentsOfFile: filepath)
        guard let APIKey = propertyList?.value(forKey: name) as? String else { print("Improper drilling into PropertyList file."); return "" }
        return APIKey
    }
}
