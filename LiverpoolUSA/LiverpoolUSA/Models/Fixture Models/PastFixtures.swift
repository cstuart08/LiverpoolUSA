//
//  PastFixtures.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/17/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

struct PastFixture: Codable {
    
    let date: String
    let time: String
    let homeTeamName: String
    let awayTeamName: String
    let location: String?
    let league: Int
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case time = "time"
        case homeTeamName = "home_name"
        case awayTeamName = "away_name"
        case location = "location"
        case league = "league_id"
        case score = "score"
    }
}

struct PastFixturesTopLevelObject: Codable {
    let data: PastFixturesSecondLevelObject
}

struct PastFixturesSecondLevelObject: Codable {
    let match: [PastFixture]
}
