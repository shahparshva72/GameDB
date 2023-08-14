//
//  ExploreView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/1/23.
//

import SwiftUI

enum GameCategory: String, CaseIterable {
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
}


struct ExploreView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(GameCategory.allCases, id: \.self) { category in
                        NavigationLink(destination: EmptyView()) {
                            ExploreCategory(category: category.description)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}


struct ExploreCategory: View {
    var category: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(LinearGradient(colors: [Color.red.opacity(0.8), Color.blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .frame(width: 150, height: 150)
            
            Text(category)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
