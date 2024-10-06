import SwiftUI

enum GameMode: Int, CaseIterable {
    case singlePlayer = 1
    case multiplayer
    case cooperative
    case splitScreen
    case mmo // Massively Multiplayer Online
    case battleRoyale

    var name: String {
        switch self {
        case .singlePlayer:
            return "Single Player"
        case .multiplayer:
            return "Multiplayer"
        case .cooperative:
            return "Co-operative"
        case .splitScreen:
            return "Split Screen"
        case .mmo:
            return "Massively Multiplayer Online (MMO)"
        case .battleRoyale:
            return "Battle Royale"
        }
    }

    var url: URL? {
        switch self {
        case .singlePlayer:
            return URL(string: "https://www.igdb.com/game_modes/single-player")
        case .multiplayer:
            return URL(string: "https://www.igdb.com/game_modes/multiplayer")
        case .cooperative:
            return URL(string: "https://www.igdb.com/game_modes/co-operative")
        case .splitScreen:
            return URL(string: "https://www.igdb.com/game_modes/split-screen")
        case .mmo:
            return URL(string: "https://www.igdb.com/game_modes/massively-multiplayer-online-mmo")
        case .battleRoyale:
            return URL(string: "https://www.igdb.com/game_modes/battle-royale")
        }
    }

    func view() -> some View {
        VStack {
            Text(name)
                .font(.title)
            Button("Learn More") {
                if let url = self.url {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
