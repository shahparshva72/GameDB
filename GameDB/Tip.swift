//
//  Tip.swift
//  GameDB
//
//  Created by Parshva Shah on 10/14/24.
//

import Foundation
import TipKit

struct AddGameTip: Tip {
    var title: Text {
        Text("Add Game")
    }

    var message: Text? {
        Text(
            "Tap on \(Image(systemName: "plus")) to save a game and see them in summary."
        )
    }
}

struct SwitchGameCategoryTip: Tip {
    var title: Text {
        Text("Explore Game Categories")
    }

    var message: Text? {
        Text("Tap to browse games by category, including highly rated, new releases, upcoming titles, and fan favorites.")
    }
}
