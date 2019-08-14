//
//  RepresentativeController.swift
//  WhyiOS
//
//  Created by Sam LoBue on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    
    static func searchRepresentatives(forState state: String, completion: @escaping ([Representative]) -> Void) {
        
        let dictionary = ["state" : state, "output": "json" ]
        let urlQueryItems = [URLQueryItem(name: "state", value: dictionary["state"]), URLQueryItem(name: "output", value: dictionary["output"])]
        var urlComponents = URLComponents(string: "https://whoismyrepresentative.com/getall_reps_bystate.php")
        urlComponents?.queryItems = urlQueryItems
        guard let finalURL = urlComponents?.url else { completion([]); return}
        print(finalURL)

        let request = URLRequest(url: finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion([]); print(error); return
            }
            
            guard let data = data else {
                completion([]); return
            }
            
            guard let convertedData = String(data: data, encoding: .utf8) else { return }
            guard let convertedDataTwo = convertedData.data(using: .utf8) else { return }
            
            do {
                let decoder = JSONDecoder()
                let representatives = try decoder.decode([String: [Representative]].self, from: convertedDataTwo)
                
                guard let representativeArray = representatives["results"] else { return }
                print(representativeArray)
                completion(representativeArray)
            } catch {
                print(error)
                print(error.localizedDescription)
                completion([])
                return
            }
        }.resume()
    }
}
