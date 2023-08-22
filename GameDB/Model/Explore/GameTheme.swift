import SwiftUI

enum GameTheme: Int, CaseIterable {
    case thriller = 20
    case scienceFiction = 18
    case action = 1
    case horror = 19
    case survival = 21
    case fantasy = 17
    case historical = 22
    case stealth = 23
    case comedy = 27
    case business = 28
    case drama = 31
    case nonFiction = 32
    case kids = 35
    case sandbox = 33
    case openWorld = 38
    case warfare = 39
    case fourX = 41  // Represented as 4X (explore, expand, exploit, and exterminate)
    case educational = 34
    case mystery = 43
    case party = 40
    case romance = 44

    var description: String {
        switch self {
        case .thriller: return "Thriller"
        case .scienceFiction: return "Science fiction"
        case .action: return "Action"
        case .horror: return "Horror"
        case .survival: return "Survival"
        case .fantasy: return "Fantasy"
        case .historical: return "Historical"
        case .stealth: return "Stealth"
        case .comedy: return "Comedy"
        case .business: return "Business"
        case .drama: return "Drama"
        case .nonFiction: return "Non-fiction"
        case .kids: return "Kids"
        case .sandbox: return "Sandbox"
        case .openWorld: return "Open world"
        case .warfare: return "Warfare"
        case .fourX: return "4X (explore, expand, exploit, and exterminate)"
        case .educational: return "Educational"
        case .mystery: return "Mystery"
        case .party: return "Party"
        case .romance: return "Romance"
        }
    }

    // func showView() -> some View {
    //     // For now, simply returning a Text view with the description
    //     return Text(self.description)
    // }
}
