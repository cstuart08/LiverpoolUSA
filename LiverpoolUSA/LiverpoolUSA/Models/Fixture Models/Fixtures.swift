//
//  Fixtures.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

struct Fixture: Codable {
    
    let date: String
    let time: String
    let homeTeamName: String
    let awayTeamName: String
    let location: String?
    let league: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case time = "time"
        case homeTeamName = "home_name"
        case awayTeamName = "away_name"
        case location = "location"
        case league = "league_id"
    }
}

struct FixtureTopLevelObject: Codable {
    let data: FixtureSecondLevelObject
}

struct FixtureSecondLevelObject: Codable {
    let fixtures: [Fixture]
}
