//
//  Place.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/20/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

struct Place: Codable {
    
    var name: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "formatted_address"
    }
}

struct PlaceTopLevelObject: Codable {
    let results: [Place]
}
