//
//  APIManager.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/22.
//

import Foundation
import IGDB_SWIFT_API

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    lazy var wrapper: IGDBWrapper = IGDBWrapper(clientID: Constants.clientID, accessToken: Constants.accessToken)
    
    /// Fetches popular games for a given platform
    /// - Parameters:
    ///   - platform: pass in a platform model
    ///   - completion: returns an array of GameModels
    func getPopularGames(for platform: PlatformModel, completion: @escaping (Result<[GameModel], Error>) -> Void) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = (\(platform.rawValue)) & rating >= 85 & themes != 42); sort first_release_date desc; limit 10;") { bytes in
            guard let gameResults = try? Proto_GameResult(serializedData: bytes) else {
                return
            }
            let games = gameResults.games.map { GameModel(game: $0, coverSize: .COVER_BIG) }
            DispatchQueue.main.async {
                completion(.success(games))
            }
            
        } errorResponse: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        
    }
    
    /// Fetches a game for a given id
    /// - Parameters:
    ///  - id: pass in a game id
    /// - completion: returns a GameModel with all the details
    func fetchGame(id: Int, completion: @escaping (Result<GameModel, Error>) -> Void) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, summary, genres.name, storyline, first_release_date, screenshots.image_id, id, rating, cover.image_id, involved_companies.company.name, videos.video_id; where id = \(id);", dataResponse: { (bytes) -> (Void) in
            guard let protoGame = try? Proto_GameResult(serializedData: bytes).games.first else {
                return
            }
            DispatchQueue.main.async {
                completion(.success(GameModel(game: protoGame, coverSize: .HD)))
            }
        }) { error  in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlatformDetails(completion: @escaping (Result<[GamePlatformModel], Error>) -> Void) {
        wrapper.apiProtoRequest(endpoint: .PLATFORMS, apicalypseQuery: "fields name, platform_logo.image_id, platform_logo.url; where category=1; limit 100;") { (bytes) -> (Void) in
            guard let platformResults = try? Proto_PlatformResult(serializedData: bytes) else {
                return
            }
            
            let consoles = platformResults.platforms.map {
                GamePlatformModel(platform: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(consoles))
            }
        } errorResponse: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        
    }
    
    func getUpcomingGames(completion: @escaping (Result<[GameModel], Error>) -> Void) {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (first_release_date > \(currentTimestamp) & themes != 42); sort first_release_date asc; limit 10;") { bytes in
            
            guard let gameResults = try? Proto_GameResult(serializedData: bytes) else {
                return
            }
            
            let games = gameResults.games.map { GameModel(game: $0, coverSize: .HD) }
            
            DispatchQueue.main.async {
                completion(.success(games))
            }
            
        } errorResponse: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    /// Search games for a given query
    /// - Parameters:
    ///   - query: pass in a string to search for
    ///   - completion: returns an array of GameModels
    func searchGames(for query: String, completion: @escaping (Result<[GameModel], RequestException>) -> Void) {
        let apicalypseQuery = "fields name, first_release_date, id, rating, cover.image_id; search \"\(query)\";"
        
        wrapper.apiJsonRequest(endpoint: .GAMES, apicalypseQuery: apicalypseQuery) { jsonString in
            guard let jsonData = jsonString.data(using: .utf8),
                  let gameResponses = try? JSONDecoder().decode([GameResponse].self, from: jsonData)
            else {
                print("Failed to load data")
                return
            }
            
            let games = gameResponses.map { GameModel(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(games))
            }
            
        } errorResponse: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    // function with an apicalypse query to fetch popular game characters using IGDB API 
    func popularCharacters() {
        wrapper.apiProtoRequest(endpoint: .CHARACTERS, apicalypseQuery: "fields name, games.name, games.cover.image_id, games.rating, games.first_release_date; where games.rating >= 85 & games.cover != null; sort games.rating desc; limit 10;") { bytes in
            guard let characterResults = try? Proto_CharacterResult(serializedData: bytes) else {
                return
            }
            
            let characters = characterResults.characters.map { CharacterModel(character: $0) }
            
            print(characters)
            
        } errorResponse: { error in
            print(error)
        }
    }

    // function with an apicalypse query to show games as per the genre selected by the user, pass genre as a parameter
    func gamesByGenre(for genre: GameGenre) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (genres = (\(genre.rawValue)) & rating >= 85 & themes != 42); sort first_release_date desc; limit 10;") { bytes in
            guard let gameResults = try? Proto_GameResult(serializedData: bytes) else {
                return
            }
            
            let games = gameResults.games.map { GameModel(game: $0, coverSize: .HD) }
            
            print(games)
            
        } errorResponse: { error in
            print(error)
        }
    }

    // function with an apicalypse query to show games as per the age_rating selected by the user, pass age_rating as a parameter
    /// - Parameters:
    ///  - ageRating: pass in an age rating
    ///  - completion: returns an array of GameModels
    func gamesByAgeRating(for ageRating: AgeRatings) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (age_ratings = (\(ageRating.rawValue)) & rating >= 85 & themes != 42); sort first_release_date desc; limit 10;") { bytes in
            guard let gameResults = try? Proto_GameResult(serializedData: bytes) else {
                return
            }
            
            let games = gameResults.games.map { GameModel(game: $0, coverSize: .HD) }
            
            print(games)
            
        } errorResponse: { error in
            print(error)
        }
    }

    // TODO: - Complete the remaining ExploreView functions using apicalypse queries and IGDB API
}

fileprivate extension GamePlatformModel {
    init(platform: Proto_Platform) {
        self.init(id: Int(platform.id),
                  name: platform.name,
                  platformLogo: Platform_Logo(
                    id: Int(platform.platformLogo.id),
                    image_id: platform.platformLogo.imageID,
                    urlString: platform.platformLogo.url
                  )
        )
    }
}

struct GameResponse: Decodable {
    let id: Int
    let name: String
    let first_release_date: Double?
    let rating: Double?
    let cover: Cover?
    
    struct Cover: Decodable {
        let id: Int
        let image_id: String
    }
}


fileprivate extension GameModel {
    init(from response: GameResponse) {
        self.id = response.id
        self.name = response.name
        self.releaseDate = Date(timeIntervalSince1970: response.first_release_date ?? 0)
        self.rating = response.rating ?? 0.0
        let imageID = response.cover?.image_id ?? ""
        self.coverURLString = imageBuilder(imageID: imageID, size: .COVER_SMALL, imageType: .JPEG)
        self.storyline = ""
        self.summary = ""
        self.screenshotURLsString = []
        self.genres = []
        self.company = ""
        self.videoIDs = []
    }
    
    init(game: Proto_Game, coverSize: ImageSize = .COVER_SMALL) {
        let coverURL = imageBuilder(imageID: game.cover.imageID, size: coverSize, imageType: .JPEG)
        
        let screenshotURLs = game.screenshots.map { (scr) -> String in
            let url = imageBuilder(imageID: scr.imageID, size: .SCREENSHOT_MEDIUM, imageType: .JPEG)
            return url
        }
        
        let videoIDs = game.videos.map { $0.videoID }
        
        let company = game.involvedCompanies.first?.company.name ?? ""
        let genres = game.genres.map { $0.name }
        self.init(
            id: Int(game.id),
            name: game.name,
            storyline: game.storyline,
            summary: game.summary,
            releaseDate: game.firstReleaseDate.date,
            rating: game.rating,
            coverURLString: coverURL,
            screenshotURLsString: screenshotURLs,
            genres: genres, company: company,
            videoIDs: videoIDs
        )
    }
}

struct CharacterModel {
    let id: Int
    let name: String
    let games: [GameModel]
    
    init(character: Proto_Character) {
        self.id = Int(character.id)
        self.name = character.name
        self.games = character.games.map { GameModel(game: $0, coverSize: .COVER_BIG) }
    }
}