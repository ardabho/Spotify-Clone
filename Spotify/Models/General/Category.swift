//
//  Category.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 7.11.2023.
//

import Foundation

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
