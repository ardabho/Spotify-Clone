//
//  APICaller.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init () {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
        static let country = "US"
    }
    
    enum APIError: Error {
        case failedToGetData
        case dataParsingFailed
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    // MARK: - Generic Request Function
    
    private func performRequest<T: Decodable>(
        with url: URL?,
        method: HTTPMethod,
        responseObjectType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            //print("url is ", apiURL)
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            request.httpMethod = method.rawValue
            request.timeoutInterval = 30
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
//                if let dataString = String(data: data, encoding: .utf8) {
//                    print("Response Data as String: \(dataString)")
//                } else {
//                    print("Failed to convert data to string")
//                }

                do {
                    let decodedObject = try JSONDecoder().decode(responseObjectType, from: data)
                    completion(.success(decodedObject))
                    
                    //I can reuse this in the future:
                 } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                     
                } catch let DecodingError.keyNotFound(key, context) {
                    print("\n\nKey '\(key)' not found:", context.debugDescription)
                    print("\ncodingPath:", context.codingPath)
                    
                } catch let DecodingError.valueNotFound(value, context) {
                    print("\n\nValue '\(value)' not found:", context.debugDescription)
                    print("\ncodingPath:", context.codingPath)
                    
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("\n\nType '\(type)' mismatch:", context.debugDescription)
                    print("\ncodingPath:", context.codingPath)
                    
                } catch {
                    print("error: ", error)
                }
                
            }.resume()
        }
    }
    
    private func printResponseAsJSON(
        with url: URL?,
        method: HTTPMethod,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = method.rawValue
            request.timeoutInterval = 30
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(results)
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    // MARK: - Specific API Calls
    
    ///Get Json data printed. For modeling purposes only
    public func getJson(with query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: Constants.baseAPIURL + "/search?type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=2")
        printResponseAsJSON(with: url, method: .GET) { _ in
            
        }
    }
    
    ///A single album
    public func getAlbum(id: String, completion: @escaping (Result<AlbumResponse, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/albums/\(id)")
        performRequest(with: url, method: .GET, responseObjectType: AlbumResponse.self, completion: completion)
    }
    
    //MARK: Playlist API
    
    ///Get a single Playlist
    public func getPlaylist(id: String, completion: @escaping(Result<PlaylistResponse, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/playlists/\(id)")

        performRequest(with: url, method: .GET, responseObjectType: PlaylistResponse.self, completion: completion)
    }
    
    ///Get the current logged in users playlists
    public func getCurrentUserPlaylists(completion: @escaping (Result<UserPlaylistsResponse, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/me/playlists")
        performRequest(with: url, method: .GET, responseObjectType: UserPlaylistsResponse.self, completion: completion)
    }
    
    ///Get recommended tracks
    public func getRecommendations(genres: [String],completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let commaSeparatedGenres = genres.joined(separator: ",")
        let url = URL(string: "\(Constants.baseAPIURL)/recommendations?seed_genres=\(commaSeparatedGenres)&country=\(Constants.country)")
        performRequest(with: url, method: .GET, responseObjectType: RecommendationsResponse.self, completion: completion)
    }
    
    ///Get current users profile info
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/me")
        performRequest(with: url, method: .GET, responseObjectType: UserProfile.self, completion: completion)
    }
    
    ///Get Featured playlists by spotify
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/browse/featured-playlists?limit=20&country=\(Constants.country)")
        performRequest(with: url, method: .GET, responseObjectType: FeaturedPlaylists.self, completion: completion)
        
    }
    
    ///New released albums
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/browse/new-releases?limit=50&country=\(Constants.country)")
        performRequest(with: url, method: .GET, responseObjectType: NewReleasesResponse.self, completion: completion)
    }
    
    ///Genres list to get recommendations
    public func getGenres (completion: @escaping (Result<Genres, Error>) -> Void) {
        let url = URL(string: "\(Constants.baseAPIURL)/recommendations/available-genre-seeds")
        performRequest(with: url, method: .GET, responseObjectType: Genres.self, completion: completion)
    }
    
    ///Get a list of categories
    public func getCategories(completion: @escaping((Result<CategoriesResponse, Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseAPIURL)/browse/categories?country=\(Constants.country)")
        performRequest(with: url, method: .GET, responseObjectType: CategoriesResponse.self, completion: completion)
    }
    
    ///Get playlist from that category
    public func getCategoryPlaylists(id: String, completion: @escaping((Result<CategoryPlaylistsResponse, Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseAPIURL)/browse/categories/\(id)/playlists")
        performRequest(with: url, method: .GET, responseObjectType: CategoryPlaylistsResponse.self, completion: completion)
    }
    
    ///search
    public func search(with query: String, completion: @escaping(Result<SearchResultsResponse, Error>) -> Void) {
        let url = URL(string: Constants.baseAPIURL + "/search?type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=6")
        performRequest(with: url, method: .GET, responseObjectType: SearchResultsResponse.self, completion: completion)
    }
    
    ///Get Users Saved Albums
    public func getUserAlbums(completion: @escaping(Result<UserAlbumsResponse, Error>) -> Void) {
        let url = URL(string: Constants.baseAPIURL + "/me/albums")
        performRequest(with: url, method: .GET, responseObjectType: UserAlbumsResponse.self, completion: completion)
    }
}
