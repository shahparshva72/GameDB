import SwiftUI

enum ExploreCategory: String, CaseIterable {
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
    
    @ViewBuilder
    func showView() -> some View {
        switch self {
        case .genres:
            GenresView()
        case .platforms:
            PlatformsView()
        case .companies:
            CompaniesView()
        case .franchises:
            FranchisesView()
        case .gameEngines:
            GameEnginesView()
        case .themes:
            GameThemesView()
        case .playerPerspective:
            PlayerPersceptiveView()
        case .modes:
            GameModesView()
        case .ageRatings:
            AgeRatingsView()
        }
    }
}
