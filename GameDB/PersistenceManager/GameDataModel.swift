//
//  GameDataModel.swift
//  GameDB
//
//  Created by Parshva Shah on 10/7/23.
//

import Foundation
import CoreData

final class GameDataModel: NSManagedObject, Identifiable {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var releaseDate: Date
    @NSManaged var coverURLString: String
    @NSManaged var isFavorite: Bool
    @NSManaged var isPlayed: Bool
    @NSManaged var isToPlay: Bool
    @NSManaged var isUpcoming: Bool
    @NSManaged var isPlaying: Bool
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(false, forKey: "isFavorite")
        setPrimitiveValue(false, forKey: "isPlayed")
        setPrimitiveValue(false, forKey: "isToPlay")
        setPrimitiveValue(false, forKey: "isUpcoming")
        setPrimitiveValue(false, forKey: "isPlaying")
    }
}

extension GameDataModel {
    static var gamesFetchRequest: NSFetchRequest<GameDataModel> {
        NSFetchRequest(entityName: "GameDataModel")
    }
}
