//
//  PastFixturesController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/18/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

class PastFixturesController {
    
    static func getPastFixtures(completion: @escaping ([PastFixture]) -> Void) {
        
        guard let baseURL = URL(string: "https://livescore-api.com/api-client/scores/history.json?") else { completion([]); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: APIKeyManager.retrieveAPIKey(name: "LiveScoreKey"))
        let urlQueryItemSecret = URLQueryItem(name: "secret", value: APIKeyManager.retrieveAPIKey(name: "LiveScoreSecret"))
        let urlQueryItemTeam = URLQueryItem(name: "team", value: "7")
        let urlQueryItemFromDate = URLQueryItem(name: "from", value: "2020-08-01")
        components?.queryItems = [urlQueryItemkey, urlQueryItemSecret, urlQueryItemTeam, urlQueryItemFromDate]
        
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
                let pastFixtureTopLevelObject = try decoder.decode(PastFixturesTopLevelObject.self, from: data)
                let pastFixtures = pastFixtureTopLevelObject.data.match
                print("Success gettings past fixtures.")
                completion(pastFixtures)
            } catch {
                print("Error getting fixtures. \(#function) - \(error) - \(error.localizedDescription)")
                completion([])
            }
            
        }.resume()
        return
    }
    
}
