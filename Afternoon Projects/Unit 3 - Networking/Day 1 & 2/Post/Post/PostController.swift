//
//  PostController.swift
//  Post
//
//  Created by Sam LoBue on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController: Codable {
    
    static let sharedInstance = PostController()
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    // MARK: - SoT
    
    var posts: [Post] = []
    
    func fetchPosts(completion: @escaping() -> Void) {
        
        guard let unwrappedURL = baseURL else { return }
        
        let getterEndpoint = unwrappedURL.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        
        request.httpBody = nil
        
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
       
            if let error = error {
                print(error)
                completion();
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                // use the data that came back. And trun it into our custom swift object so we can display it to the user
                let postsDictionary = try jsonDecoder.decode([String: Post].self, from: data)
                var posts = postsDictionary.compactMap({ $0.value })
                posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
                
            } catch let error {
                print(error)
            }
            
            }
        dataTask.resume()
    }
    
}
