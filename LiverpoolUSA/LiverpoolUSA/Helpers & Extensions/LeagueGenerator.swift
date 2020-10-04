//
//  LeagueGenerator.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/17/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

struct LeagueNameConstants {
    static let premierLeague = "Premier League"
    static let championsLeague = "Champions League"
    static let uefaSuperCup = "UEFA Super Cup"
    static let carabaoCup = "Carabao Cup"
    static let communityShield = "Community Shield"
    static let clubFriendly = "Club Friendy"
}

struct LeagueGenerator {
    
    static func leagueNameGenerator(id: String?, intID: Int?) -> String{
        
        switch id {
        case _ where id == "25":
            return LeagueNameConstants.premierLeague
        case _ where intID == 25:
            return LeagueNameConstants.premierLeague
        case _ where id == "117":
            return LeagueNameConstants.carabaoCup
        case _ where intID == 0:
            return LeagueNameConstants.carabaoCup
        case _ where id == "232":
            return LeagueNameConstants.championsLeague
        case _ where id == "812":
            return LeagueNameConstants.uefaSuperCup
        case _ where id == "5" || intID == 5 :
            return LeagueNameConstants.clubFriendly
        case _ where intID == 731:
            return LeagueNameConstants.communityShield
        case _ where id == "0":
            return LeagueNameConstants.clubFriendly
        default:
            return "NO KNOWN ID"
        }
    }
}
