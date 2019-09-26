//
//  StandingsController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class StandingsController {
    
    static func fetchStandings(completion: @escaping ([TeamStanding]) -> Void) {
        
        guard let baseURL = URL(string: "https://livescore-api.com/api-client/leagues/table.json?") else { completion([]); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: "RVo5izZrngSvfH47")
        let urlQueryItemSecret = URLQueryItem(name: "secret", value: "WK8tYZSGtLU2aPj1LH74h6vFnoaC6fK2")
        let urlQueryItemCompetitionID = URLQueryItem(name: "competition_id", value: "2")
        let urlQueryItemSeason = URLQueryItem(name: "season", value: "4")
        components?.queryItems = [urlQueryItemkey, urlQueryItemSecret, urlQueryItemCompetitionID, urlQueryItemSeason]
        
        guard let finalURL = components?.url else { completion([]); return }
        
        let request = URLRequest(url: finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error: \(error) - \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("Error receiving data for fetchStandings")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(TopLevelObject.self, from: data)
                let standings = topLevelObject.data.table
                print("Success gettings standings.")
                completion(standings)
            } catch {
                print("Error getting standings. \(#function) - \(error) - \(error.localizedDescription)")
                completion([])
            }
            
        }.resume()
        return
    }
}
