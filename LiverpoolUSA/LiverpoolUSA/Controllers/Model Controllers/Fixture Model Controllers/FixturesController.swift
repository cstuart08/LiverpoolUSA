//
//  FixturesController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

class FixturesController {

    var placeholder: [Fixture] = []
    
    static let shared = FixturesController()
    
    // MARK: - Methods
    func getFixtures(page: String = "1", completion: @escaping (Bool) -> Void) {
        
        guard let baseURL = URL(string: "https://livescore-api.com/api-client/fixtures/matches.json?") else { completion(false); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: "RVo5izZrngSvfH47")
        let urlQueryItemSecret = URLQueryItem(name: "secret", value: "WK8tYZSGtLU2aPj1LH74h6vFnoaC6fK2")
        let urlQueryItemTeam = URLQueryItem(name: "team", value: "7")
        let urlQueryItemPage = URLQueryItem(name: "page", value: page)
        components?.queryItems = [urlQueryItemkey, urlQueryItemSecret, urlQueryItemTeam, urlQueryItemPage]
        
        guard let finalURL = components?.url else { completion(false); return }
        
        let request = URLRequest(url: finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error: \(error) - \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("Error receiving data for fetchStandings")
                completion(false)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let fixtureTopLevelObject = try decoder.decode(FixtureTopLevelObject.self, from: data)
                let fixtures = fixtureTopLevelObject.data.fixtures
                print("Success gettings fixtures for page \(page).")
                if page == "1" {
                    self.placeholder.append(contentsOf: fixtures)
                    print("begin fetching page 2 fixtures")
                    FixturesController.shared.getFixtures(page: "2") { (page2Fixtures) in
                        print("successfully fetched page 2 fixtures")
                        completion(true)
                    }
                } else {
                    self.placeholder.append(contentsOf: fixtures)
                    completion(true)
                }
            } catch {
                print("Error getting fixtures. \(#function) - \(error) - \(error.localizedDescription)")
                completion(false)
                return
            }
            
        }.resume()
        //return
    }
}
