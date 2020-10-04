//
//  EventLocationAPICall.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/19/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceManager {
    
    static func fetchPlaces(searchTerm: String, completion: @escaping ([Place]) -> Void) {
        
        let locationCoordinates = LocationManager.shared.currentLocation ?? CLLocation(latitude: 0, longitude: 0)
        
        guard let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?") else { completion([]); return }
        let location = "\(locationCoordinates.coordinate.latitude),\(locationCoordinates.coordinate.longitude)"
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlQueryItemkey = URLQueryItem(name: "key", value: APIKeyManager.retrieveAPIKey(name: "GooglePlacesKey"))
        let urlQueryItemType = URLQueryItem(name: "inputtype", value: "textquery")
        let urlQueryItemInput = URLQueryItem(name: "input", value: searchTerm)
        let locationQuery = URLQueryItem(name: "location", value: location)
        let radiusQuery =  URLQueryItem(name: "radius", value: "10000")
        components?.queryItems = [urlQueryItemkey, urlQueryItemType, urlQueryItemInput,locationQuery, radiusQuery]
        
        guard let finalURL = components?.url else { completion([]); return }
        
        print(finalURL)
        
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
