//
//  TeamStanding.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/13/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

struct TeamStanding: Codable {
    
    let teamRank: String
    let teamName: String
    let matchesPlayed: String
    let matchesWon: String
    let matchesDrawn: String
    let matchesLost: String
    let goalsScored: String
    let goalsConceded: String
    let goalDifference: String
    let teamPoints: String
    
    enum CodingKeys: String, CodingKey {
        case teamRank = "rank"
        case teamName = "name"
        case matchesPlayed = "matches"
        case matchesWon = "won"
        case matchesDrawn = "drawn"
        case matchesLost = "lost"
        case goalsScored = "goals_scored"
        case goalsConceded = "goals_conceded"
        case goalDifference = "goal_diff"
        case teamPoints = "points"
    }
}

struct TopLevelObject: Codable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Codable {
    let table: [TeamStanding]
}
