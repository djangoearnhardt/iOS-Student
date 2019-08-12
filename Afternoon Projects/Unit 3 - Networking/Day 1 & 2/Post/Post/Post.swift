//
//  Post.swift
//  Post
//
//  Created by Sam LoBue on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct JsonDictionary: Decodable {
    
    let posts: [Post]
}


struct Post: Codable {
    var text: String
    var username: String
    var timestamp: Double
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
}
