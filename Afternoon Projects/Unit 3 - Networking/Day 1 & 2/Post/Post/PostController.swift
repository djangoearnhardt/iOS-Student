//
//  PostController.swift
//  Post
//
//  Created by Sam LoBue on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController: Codable {
    
//    static let sharedInstance = PostController()
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    // MARK: - SoT
    
    var posts: [Post] = []
    
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        
//        var reset: Bool = true
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        
        guard let unwrappedURL = baseURL else { return }
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
        ]
        
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        let getterEndpoint = url.appendingPathExtension("json")
        
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
                if reset == true {
                    self.posts = posts
                } else {
                    self.posts.append(contentsOf: posts)
                }
                
                
                completion()
                
            } catch let error {
                print(error)
                completion()
                return
            }
            
            }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping() -> Void) {
        
        let post = Post(text: text, username: username)
        var postData: Data?
        
        do {
            let jsonEncoder = JSONEncoder()
            let je = try jsonEncoder.encode(post)
            postData = je
        } catch let error {
            print(error)
            return
        }
        
        guard let unwrappedBaseURL = baseURL else { return }
        let postEndpoint = unwrappedBaseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        
        request.httpBody = postData
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("\(error) : \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else { return }
            let printableData = String(data: data, encoding: .utf8)
            self.posts.append(post)
            print(printableData)
            
            self.fetchPosts(completion: {
                completion()
            })
            
        }
        dataTask.resume()
    }
    
}
