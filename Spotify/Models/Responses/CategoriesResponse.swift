//
//  CategoriesResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 7.11.2023.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    
}
