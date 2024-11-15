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
        NavigationItem(category: .genres, icon: "arcade.stick.console"),
        NavigationItem(category: .platforms, icon: "desktopcomputer"),
        NavigationItem(category: .themes, icon: "sparkles"),
        NavigationItem(category: .playerPerspective, icon: "person.crop.circle"),
        NavigationItem(category: .modes, icon: "rectangle.connected.to.line.below"),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(navigationItems) { item in
                    NavigationLink(value: item) {
                        ExploreCategoryView(category: item.title, icon: item.icon)
                    }
                }
            }
        }
        .padding(20)
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
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: "#791a97").opacity(0.9), Color(hex: "#791a97").opacity(0.6)], startPoint: .top, endPoint: .bottom))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)

            VStack(spacing: 15) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)

                Text(category)
                    .pixelatedFont(size: 12)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.horizontal, 4)
            }
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.4), lineWidth: 2)
        )
        .aspectRatio(1, contentMode: .fill)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
