import SwiftUI

enum ExploreCategory: String, CaseIterable {
    case genres = "Genres"
    case platforms = "Platforms"
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
