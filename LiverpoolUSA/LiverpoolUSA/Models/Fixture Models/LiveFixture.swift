//
//  LiveFixture.swift
//  LiverpoolUSA
//
//  Created by Cameron Stuart on 9/21/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

struct LiveFixture: Codable {
    
    let time: String
    let homeTeamName: String
    let awayTeamName: String
    let location: String?
    let league: Int
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case homeTeamName = "home_name"
        case awayTeamName = "away_name"
        case location = "location"
        case league = "league_id"
        case score = "score"
    }
}

struct LiveFixturesTopLevelObject: Codable {
    let data: LiveFixturesSecondLevelObject
}

struct LiveFixturesSecondLevelObject: Codable {
    let match: [LiveFixture]
}
