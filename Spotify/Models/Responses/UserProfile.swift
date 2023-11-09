import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let country, display_name, email: String
    let explicit_content: [String: Bool]
    let id, product: String
    let images: [APIImage]
}


