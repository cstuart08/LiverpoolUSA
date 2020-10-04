//
//  TeamLogoManager.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/18/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class TeamLogoManager {
    
    static let shared = TeamLogoManager()
    
    private struct LogoTopLevelObject: Codable {
        let teams: [LogoSecondLevelObject]
    }
    
    private struct LogoSecondLevelObject: Codable {
        let strTeamBadge: String?
    }
    
    private init() {}
    
    func getLogos(fixture: Fixture?, pastFixture: PastFixture?, liveFixture: LiveFixture?, completion: @escaping ((UIImage, UIImage)) -> Void) {
        
        var homeLogo: UIImage?
        var awayLogo: UIImage?
        
        if let fixture = fixture {
            getTeamLogo(teamName: fixture.homeTeamName) { (receivedHomeLogo) in
                homeLogo = receivedHomeLogo
                if let awayLogo = awayLogo {
                    completion((receivedHomeLogo, awayLogo))
                }
            }
            getTeamLogo(teamName: fixture.awayTeamName) { (receivedAwayLogo) in
                awayLogo = receivedAwayLogo
                if let homeLogo = homeLogo {
                    completion((homeLogo, receivedAwayLogo))
                }
            }
        }
        
        if let pastFixture = pastFixture {
            getTeamLogo(teamName: pastFixture.homeTeamName) { (receivedHomeLogo) in
                homeLogo = receivedHomeLogo
                if let awayLogo = awayLogo {
                    completion((receivedHomeLogo, awayLogo))
                }
            }
            getTeamLogo(teamName: pastFixture.awayTeamName) { (receivedAwayLogo) in
                awayLogo = receivedAwayLogo
                if let homeLogo = homeLogo {
                    completion((homeLogo, receivedAwayLogo))
                }
            }
        }
        
        if let liveFixture = liveFixture {
            getTeamLogo(teamName: liveFixture.homeTeamName) { (receivedHomeLogo) in
                homeLogo = receivedHomeLogo
                if let awayLogo = awayLogo {
                    completion((receivedHomeLogo, awayLogo))
                }
            }
            getTeamLogo(teamName: liveFixture.awayTeamName) { (receivedAwayLogo) in
                awayLogo = receivedAwayLogo
                if let homeLogo = homeLogo {
                    completion((homeLogo, receivedAwayLogo))
                }
            }
        }
        
    }
    
    var logoCache: [String : UIImage] = [
        // Premiere League Teams
        "Liverpool" : #imageLiteral(resourceName: "Liverpool"),
        "Tottenham Hotspur" : #imageLiteral(resourceName: "Tottenham Hotspur"),
        "Manchester City" : #imageLiteral(resourceName: "Manchester City"),
        "Leicester City" : #imageLiteral(resourceName: "Leicester City"),
        "Arsenal" : #imageLiteral(resourceName: "Arsenal"),
        "West Ham United" : #imageLiteral(resourceName: "West Ham United"),
        "AFC Bournemouth" : #imageLiteral(resourceName: "AFC Bournemouth"),
        "Manchester United" : #imageLiteral(resourceName: "Manchester United"),
        "Burnley" : #imageLiteral(resourceName: "Burnley"),
        "Sheffield United" : #imageLiteral(resourceName: "Sheffield United"),
        "Chelsea" : #imageLiteral(resourceName: "Chelsea"),
        "Crystal Palace" : #imageLiteral(resourceName: "Crystal Palace"),
        "Southampton" : #imageLiteral(resourceName: "Southampton"),
        "Everton" : #imageLiteral(resourceName: "Everton"),
        "Brighton & Hove Albion" : #imageLiteral(resourceName: "Brighton & Hove Albion"),
        "Norwich City" : #imageLiteral(resourceName: "Norwich City"),
        "Newcastle United" : #imageLiteral(resourceName: "Newcastle United"),
        "Aston Villa" : #imageLiteral(resourceName: "Aston Villa"),
        "Wolverhampton Wanderers" : #imageLiteral(resourceName: "Wolverhampton Wanderers"),
        "Watford" : #imageLiteral(resourceName: "Watford"),
        "Leeds United" : UIImage(named: "Leeds United")!,
        "West Bromwich Albion" : UIImage(named: "West Bromwich Albion")!,
        "Fulham" : UIImage(named: "Fulham")!,
        // 2019-2020 Other Opposing Teams
        "Milton Keynes Dons" : #imageLiteral(resourceName: "Milton Keynes Dons"),
        "Genk" : #imageLiteral(resourceName: "Genk"),
        "Salzburg" : #imageLiteral(resourceName: "Salzburg"),
        "SSC Napoli": #imageLiteral(resourceName: "SSC Napoli"),
        "Napoli": #imageLiteral(resourceName: "SSC Napoli"),
        "Lincoln City" : UIImage(named: "Lincoln City")!,
        "VfB Stuttgart" : UIImage(named: "VfB Stuttgart")!,
        "Blackpool" : UIImage(named: "Blackpool")!,
        "Midtjylland" : UIImage(named: "Midtjylland")!,
        "Inter Milan" : UIImage(named: "Inter Milan")!,
        "Ajax" : UIImage(named: "Ajax")!,
        "Atalanta" : UIImage(named: "Atalanta")!,
        "MGladbach" : UIImage(named: "MGladbach")!,
        // NO MATCH
        "noMatch": #imageLiteral(resourceName: "noImageAvailable")
    ]
    
    func getTeamLogo(teamName: String, completion: @escaping (UIImage) -> Void) {
        
        if let teamLogo = logoCache[teamName] {
            completion(teamLogo)
            return
        }
        
        var apiTeamName: String = ""
        
        if teamName == "Tottenham Hotspur" {
            apiTeamName = "Tottenham"
        } else if teamName == "Leicester City" {
            apiTeamName = "Leicester"
        } else if teamName == "AFC Bournemouth" {
            apiTeamName = "Bournemouth"
        } else if teamName == "Norwich City" {
            apiTeamName = "Norwich"
        } else if teamName == "Brighton & Hove Albion" {
            apiTeamName = "Brighton"
        } else if teamName == "Newcastle United" {
            apiTeamName = "Newcastle"
        } else if teamName == "Salzburg" {
            apiTeamName = "SV Salzburg"
        } else if teamName == "SSC Napoli" {
            apiTeamName = "Napoli"
        } else {
            apiTeamName = teamName
        }
        
        guard let baseURL = URL(string: "https://www.thesportsdb.com/api/v1/json/1/searchteams.php?") else { completion(#imageLiteral(resourceName: "noImageAvailable")); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemTeam = URLQueryItem(name: "t", value: apiTeamName)
        components?.queryItems = [urlQueryItemTeam]
        
        guard let finalURL = components?.url else { completion(#imageLiteral(resourceName: "noImageAvailable")); return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error: \(error) - \(error.localizedDescription)")
                completion(#imageLiteral(resourceName: "noImageAvailable"))
                return
            }
            
            guard let data = data else {
                print("Error receiving data for team logo")
                completion(#imageLiteral(resourceName: "noImageAvailable"))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(LogoTopLevelObject.self, from: data)
                guard let teamLogoURLString = topLevelObject.teams[0].strTeamBadge else {completion(#imageLiteral(resourceName: "noImageAvailable")); return}
                self.getTeamLogoFromURL(teamName: apiTeamName,url: teamLogoURLString, completion: { (logo) in
                    completion(logo)
                })
                
            } catch {
                print(error)
                print(error.localizedDescription)
                completion(#imageLiteral(resourceName: "noImageAvailable"))
            }
            
        }.resume()
        return
    }
    
    private func getTeamLogoFromURL(teamName: String, url: String, completion: @escaping (UIImage) -> Void) {
        
        if url == "https://www.thesportsdb.com/images/media/team/badge/uvxuqq1448813372.png" {
            completion(#imageLiteral(resourceName: "Liverpool"))
            return
        }
        // CHECK IF CACHE EXISTS HERE -- if it does, complete with cache.
        
        guard let logoURL = URL(string: url) else {
            completion(#imageLiteral(resourceName: "noImageAvailable"))
            return
        }
        
        URLSession.shared.dataTask(with: logoURL) { (data, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(#imageLiteral(resourceName: "noImageAvailable"))
                return
            }
            
            guard let data = data else { completion(#imageLiteral(resourceName: "noImageAvailable")); return }
            
            guard let teamLogo = UIImage(data: data) else {
                completion(#imageLiteral(resourceName: "noImageAvailable"))
                return
            }
            
            self.logoCache[teamName] = teamLogo
            
            completion(teamLogo)
            
        }.resume()
    }
}
