//
//  LiveFixtureController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/21/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

class LiveFixtureController {
    
    static func getLiveFixtures(completion: @escaping (LiveFixture?) -> Void) {
        
        guard let baseURL = URL(string: "https://livescore-api.com/api-client/scores/live.json?") else { completion(nil); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: APIKeyManager.retrieveAPIKey(name: "LiveScoreKey"))
        let urlQueryItemSecret = URLQueryItem(name: "secret", value: APIKeyManager.retrieveAPIKey(name: "LiveScoreSecret"))
        components?.queryItems = [urlQueryItemkey, urlQueryItemSecret]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        let request = URLRequest(url: finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error: \(error) - \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error receiving data for live fixtures.")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let liveFixtureTopLevelObject = try decoder.decode(LiveFixturesTopLevelObject.self, from: data)
                let liveFixtures = liveFixtureTopLevelObject.data.match
                for fixture in liveFixtures {
                    if fixture.homeTeamName == "Liverpool" || fixture.awayTeamName == "Liverpool" {
                        print("Success getting a live fixture.")
                        completion(fixture)
                        return
                    }
                }
                completion(nil)
            } catch {
                print("Error getting a live fixture. \(#function) - \(error) - \(error.localizedDescription)")
                completion(nil)
            }
            
        }.resume()
        return
    }
}
