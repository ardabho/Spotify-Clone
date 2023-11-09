//
//  Owner.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 2.11.2023.
//

import Foundation

struct Owner: Codable {
    let displayName: String?
    let externalUrls: [String: String]
    let id: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case id, type, uri
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
