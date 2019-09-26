//
//  EventLocationAPICall.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/19/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

class PlaceManager {
    
    static func fetchPlaces(searchTerm: String, completion: @escaping ([Place]) -> Void) {
        
        guard let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?") else { completion([]); return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: "AIzaSyBGxowi_L8uc0dX3i3ipxzAV9GYlR1Jjzo")
        let urlQueryItemType = URLQueryItem(name: "inputtype", value: "textquery")
        let urlQueryItemInput = URLQueryItem(name: "input", value: searchTerm)
        components?.queryItems = [urlQueryItemkey, urlQueryItemType, urlQueryItemInput]
        
        guard let finalURL = components?.url else { completion([]); return }
        
        let request = URLRequest(url: finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error: \(error) - \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("Error receiving data for fetchPlaces")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(PlaceTopLevelObject.self, from: data)
                let places = topLevelObject.results
                print("Success gettings places.")
                completion(places)
            } catch {
                print("Error getting places. \(#function) - \(error) - \(error.localizedDescription)")
                completion([])
            }
            
        }.resume()
        return
    }
}
