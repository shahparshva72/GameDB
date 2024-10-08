//
//  ExploreView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/1/23.
//

import SwiftUI

struct NavigationItem: Hashable, Identifiable {
    var id: UUID = .init()
    var title: String
    var icon: String
    var category: ExploreCategory

    init(category: ExploreCategory, icon: String) {
        title = category.description
        self.icon = icon
        self.category = category
    }
}

struct ExploreView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20),
    ]

    let navigationItems: [NavigationItem] = [
        NavigationItem(category: .genres, icon: "gamecontroller"),
        NavigationItem(category: .platforms, icon: "desktopcomputer"),
        NavigationItem(category: .themes, icon: "sparkles"),
        NavigationItem(category: .playerPerspective, icon: "eyeglasses"),
        NavigationItem(category: .modes, icon: "network"),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(navigationItems) { item in
                    NavigationLink(value: item) {
                        ExploreCategoryView(category: item.title, icon: item.icon)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .navigationDestination(for: NavigationItem.self) { item in
            item.category.showView()
        }
    }
}

struct ExploreCategoryView: View {
    var category: String
    var icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(LinearGradient(colors: [Color.purple, Color.purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 150, height: 150)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            VStack(spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)

                Text(category)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
