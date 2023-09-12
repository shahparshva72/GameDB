enum PlayerPerspective: Int, CaseIterable {
    case firstPerson = 1
    case thirdPerson = 2
    case birdViewIsometric = 3
    case text = 5
    case sideView = 4
    case virtualReality = 7
    case auditory = 6

    var description: String {
        switch self {
        case .firstPerson: return "First person"
        case .thirdPerson: return "Third person"
        case .birdViewIsometric: return "Bird view / Isometric"
        case .text: return "Text"
        case .sideView: return "Side view"
        case .virtualReality: return "Virtual Reality"
        case .auditory: return "Auditory"
        }
    }
}
