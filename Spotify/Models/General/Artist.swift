//
//  Artist.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import Foundation

struct Artist: Codable {
    let externalUrls: [String:String]
    let id: String
    let name: String
    let images: [APIImage]?
    let type: String
    let uri: String
    let genres: [String]?
    let followers: Followers?
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case type
        case uri
        case genres
        case followers
    }
}
