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
    
    func getPopularGames(for platform: PlatformModel, completion: @escaping (Result<[GameModel], Error>) -> Void) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = (\(platform.rawValue)) & rating >= 85 & themes != 42); sort first_release_date desc; limit 50;") { bytes in
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
    
    func fetchGame(id: Int, completion: @escaping (Result<GameModel, Error>) -> Void) {
        wrapper.apiProtoRequest(endpoint: .GAMES, apicalypseQuery: "fields name, summary, genres.name, storyline, first_release_date, screenshots.image_id, id, rating, cover.image_id, involved_companies.company.name, videos.video_id; where id = \(id);", dataResponse: { (bytes) -> (Void) in
            guard let protoGame = try? Proto_GameResult(serializedData: bytes).games.first else {
                return
            }
            DispatchQueue.main.async {
                completion(.success(GameModel(game: protoGame, coverSize: .COVER_BIG)))
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
    
}

fileprivate extension GamePlatformModel {
    init(platform: Proto_Platform) {
        self.init(id: Int(platform.id),
                  name: platform.name,
                  platformLogo: Platform_Logo(id: Int(platform.platformLogo.id),
                                              image_id: platform.platformLogo.imageID,
                                              urlString: platform.platformLogo.url))
    }
}


fileprivate extension GameModel {
    
    init(game: Proto_Game, coverSize: ImageSize = .COVER_SMALL) {
        let coverURL = imageBuilder(imageID: game.cover.imageID, size: coverSize, imageType: .PNG)
        
        let screenshotURLs = game.screenshots.map { (scr) -> String in
            let url = imageBuilder(imageID: scr.imageID, size: .SCREENSHOT_MEDIUM, imageType: .JPEG)
            return url
        }
        
        let videoIDs = game.videos.map { $0.videoID }
        
        let company = game.involvedCompanies.first?.company.name ?? ""
        let genres = game.genres.map { $0.name }
        self.init(id: Int(game.id),
                  name: game.name,
                  storyline: game.storyline,
                  summary: game.summary,
                  releaseDate: game.firstReleaseDate.date,
                  rating: game.rating,
                  coverURLString: coverURL, screenshotURLsString: screenshotURLs, genres: genres, company: company, videoIDs: videoIDs)
    }
    
}

