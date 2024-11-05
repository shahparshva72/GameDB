//
//  UpcomingGamesWidget.swift
//  UpcomingGamesWatch
//
//  Created by Parshva Shah on 11/4/24.
//

import WidgetKit
import SwiftUI
import CoreData

class Provider: TimelineProvider {
    private var context = GameDataProvider.shared.viewContext
    private var notificationToken: NSObjectProtocol?
    
    init() {
        // Observe Core Data changes
        notificationToken = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: context,
            queue: .main
        ) { [weak self] _ in
            self?.reloadWidgetTimeline()
        }
    }
    
    deinit {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), games: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let games = fetchGames()
        let entry = SimpleEntry(date: Date(), games: games)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let games = fetchGames()
        let entry = SimpleEntry(date: Date(), games: games)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchGames() -> [GameDataModel] {
        let fetchRequest = NSFetchRequest<GameDataModel>(entityName: "GameDataModel")
        fetchRequest.predicate = NSPredicate(format: "releaseDate >= %@", Date() as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching games: \(error)")
            return []
        }
    }
    
    
    private func reloadWidgetTimeline() {
        WidgetCenter.shared.reloadTimelines(ofKind: "UpcomingGamesWidget")
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let games: [GameDataModel]
}

struct UpcomingGamesWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            Text("UPCOMING RELEASES")
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.top, 8)
            
            if entry.games.isEmpty {
                // Message when no upcoming games are found
                Text("No games found.\nAdd an upcoming game in the app to see it here.")
                    .font(.caption)
                    .foregroundStyle(Color.white)
                    .padding(.top, 8)
            } else {
                // Display multiple games
                ForEach(entry.games.prefix(3)) { game in
                    VStack(alignment: .leading, spacing: 2) {
                        // Game Name
                        Text(game.name)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                        
                        // Days Left Progress Bar
                        let daysLeft = max(0, Calendar.current.dateComponents([.day], from: Date(), to: game.releaseDate).day ?? 0)
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                            Text("\(daysLeft) days left")
                                .font(.caption2)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(Color.white)
                }
            }
        }
        .containerBackground(Color(red: 0 / 255.0, green: 172 / 255.0, blue: 159 / 255.0), for: .widget)
    }
}

struct UpcomingGamesWidget: Widget {
    let kind: String = "UpcomingGamesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UpcomingGamesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Games")
        .description("Keep track of upcoming games.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Preview Data
extension GameDataModel {
    static var sampleGames: [GameDataModel] {
        let context = GameDataProvider.shared.viewContext
        
        let game1 = GameDataModel(context: context)
        game1.id = 1
        game1.name = "Final Fantasy XVI"
        game1.releaseDate = Calendar.current.date(byAdding: .day, value: 15, to: Date())!
        
        let game2 = GameDataModel(context: context)
        game2.id = 2
        game2.name = "Starfield"
        game2.releaseDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        
        let game3 = GameDataModel(context: context)
        game3.id = 3
        game3.name = "Spider-Man 2"
        game3.releaseDate = Calendar.current.date(byAdding: .day, value: 45, to: Date())!
        
        return [game1, game2, game3]
    }
}

// MARK: - Preview Provider
struct UpcomingGamesWidget_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with sample data
        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: GameDataModel.sampleGames
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        // Preview empty state
        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: []
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        // Preview dark mode
        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: GameDataModel.sampleGames
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .environment(\.colorScheme, .dark)
    }
}
