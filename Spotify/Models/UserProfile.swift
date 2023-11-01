// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let country, display_name, email: String
    let explicit_content: [String: Bool]
    let id, product: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}
