//
//  Gist.swift
//  MobvenIOSTI
//
//  Created by Burak Yılmaz on 9.09.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import Foundation

struct Gist: Decodable {
    var id: String?
    var url: String?
    var description: String?
    var createdAt: String?
    var nodeId: String?
    var comments: Int?
    
    var isFavorite: Bool = false
    
    private var owner: Owner?
    var avatarUrl: String? {
        return owner?.avatarUrl
    }
    
    struct Owner: Decodable {
        var avatarUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case description
        case createdAt = "created_at"
        case comments
        case nodeId = "node_id"
        case owner
    }
}
