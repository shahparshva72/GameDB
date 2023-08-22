enum GameGenre: Int {
    case fighting = 4
    case shooter = 5
    case music = 7
    case platform = 8
    case puzzle = 9
    case racing = 10
    case rts = 11 // Real Time Strategy (RTS)
    case rpg = 12 // Role-playing (RPG)
    case simulator = 13
    case sport = 14
    case strategy = 15
    case tbs = 16 // Turn-based strategy (TBS)
    case tactical = 24
    case trivia = 26 // Quiz/Trivia
    case hackAndSlash = 25 // Hack and slash/Beat 'em up
    case pinball = 30
    case adventure = 31
    case arcade = 33
    case visualNovel = 34
    case indie = 32
    case cardAndBoard = 35 // Card & Board Game
    case moba = 36
    case pointAndClick = 2

    var description: String {
        switch self {
        case .fighting: return "Fighting"
        case .shooter: return "Shooter"
        case .music: return "Music"
        case .platform: return "Platform"
        case .puzzle: return "Puzzle"
        case .racing: return "Racing"
        case .rts: return "Real Time Strategy (RTS)"
        case .rpg: return "Role-playing (RPG)"
        case .simulator: return "Simulator"
        case .sport: return "Sport"
        case .strategy: return "Strategy"
        case .tbs: return "Turn-based strategy (TBS)"
        case .tactical: return "Tactical"
        case .trivia: return "Quiz/Trivia"
        case .hackAndSlash: return "Hack and slash/Beat 'em up"
        case .pinball: return "Pinball"
        case .adventure: return "Adventure"
        case .arcade: return "Arcade"
        case .visualNovel: return "Visual Novel"
        case .indie: return "Indie"
        case .cardAndBoard: return "Card & Board Game"
        case .moba: return "MOBA"
        case .pointAndClick: return "Point-and-click"
        }
    }
}

extension GameGenre: CaseIterable {}
