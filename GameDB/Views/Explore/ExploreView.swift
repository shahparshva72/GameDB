//
//  ExploreView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/1/23.
//

import SwiftUI

struct NavigationItem: Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var icon: String
    var category: ExploreCategory
    
    init(category: ExploreCategory, icon: String) {
        self.title = category.description
        self.icon = icon
        self.category = category
    }
}

struct ExploreView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    let navigationItems: [NavigationItem] = [
        NavigationItem(category: .genres, icon: "music.note.list"),
        NavigationItem(category: .platforms, icon: "gamecontroller"),
        NavigationItem(category: .themes, icon: "paintbrush"),
        NavigationItem(category: .playerPerspective, icon: "person.crop.circle"),
        NavigationItem(category: .modes, icon: "person.3"),
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
                .fill(LinearGradient(colors: [Color.red.opacity(0.8), Color.blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .frame(width: 150, height: 150)
            
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Text(category)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}



struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
