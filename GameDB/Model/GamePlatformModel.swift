    //
    //  GamePlatformModel.swift
    //  GameDB
    //
    //  Created by Parshva Shah on 6/18/23.
    //

import Foundation

struct GamePlatformModel: Identifiable, Decodable {
    let id: Int
    var name: String
    var platformLogo: Platform_Logo?
    
}

struct Platform_Logo: Identifiable, Decodable {
    let id: Int
    var image_id: String
    var urlString: String
    
    var url: URL? {
        return URL(string: urlString)
    }
}
