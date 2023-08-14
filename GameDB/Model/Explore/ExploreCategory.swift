enum ExploreCategoryCategory: String, CaseIterable {
    case genres = "Genres"
    case platforms = "Platforms"
    case companies = "Companies"
    case franchises = "Franchises"
    case gameEngines = "Game Engines"
    case themes = "Themes"
    case playerPerspective = "Player Perspective"
    case modes = "Modes"
    case ageRatings = "Age Ratings"
    
    var description: String {
        return self.rawValue
    }
    
    func showView() {
        switch self {
        case .genres:
            print("Genres")
        case .platforms:
            print("Platforms")
        case .companies:
            print("Companies")
        case .franchises:
            print("Franchises")
        case .gameEngines:
            print("Game Engines")
        case .themes:
            print("Themes")
        case .playerPerspective:
            print("Player Perspective")
        case .modes:
            print("Modes")
        case .ageRatings:
            print("Age Ratings")
        }
    }
}