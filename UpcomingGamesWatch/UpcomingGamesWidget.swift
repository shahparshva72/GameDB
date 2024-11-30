//
//  UpcomingGamesWidget.swift
//  UpcomingGamesWatch
//
//  Created by Parshva Shah on 11/4/24.
//

import CoreData
import SwiftUI
import WidgetKit

class Provider: TimelineProvider {
    private var context = GameDataProvider.shared.viewContext
    private var notificationToken: NSObjectProtocol?
    
    init() {
        // Observe Core Data changes
        let notificationCenter = NotificationCenter.default
        notificationToken = notificationCenter.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            // Force refresh context to ensure latest data
            self?.context.reset()
            self?.reloadWidgetTimeline()
        }
    }
    
    deinit {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), games: [])
    }
    
    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let games = fetchGames()
        let entry = SimpleEntry(date: Date(), games: games)
        completion(entry)
    }
    
    func getTimeline(in _: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
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
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let games: [GameDataModel]
}

struct UpcomingGamesWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    private var sortedGames: [GameDataModel] {
        entry.games.sorted { $0.releaseDate < $1.releaseDate }
    }
    
    private var gridColumns: [GridItem] {
        let gameCount = min(sortedGames.count, 4)
        switch gameCount {
        case 0: return []
        case 1: return [GridItem(.flexible())]
        case 2: return [GridItem(.flexible()), GridItem(.flexible())]
        default: return [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Upcoming Games")
                .font(.caption.weight(.bold).width(.expanded))
                .fontWeight(.bold)
                .padding(.top, 8)
                .foregroundStyle(.white)
            
            if sortedGames.isEmpty {
                VStack(spacing: 4) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.title3)
                    Text("NO QUESTS AVAILABLE \n Add a new game in the app to track.")
                        .font(.caption.width(.expanded))
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVGrid(columns: gridColumns, spacing: 10) {
                    ForEach(sortedGames.prefix(4)) { game in
                        GameGridCell(game: game)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .containerBackground(Color.black, for: .widget)
    }
}

struct GameGridCell: View {
    let game: GameDataModel
    
    var body: some View {
        let daysLeft = max(0, Calendar.current.dateComponents([.day], from: Date(), to: game.releaseDate).day ?? 0)
        
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 6))
                    .foregroundStyle(.yellow)
                Text(game.name)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "timer")
                    .font(.caption2)
                    .symbolEffect(.pulse, options: .repeating)
                Text("\(daysLeft)d")
                    .font(.system(.subheadline, design: .monospaced))
            }
            .foregroundStyle(progressColor(daysLeft: daysLeft))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.1))
        )
        .foregroundStyle(.white)
    }
    
    private func progressColor(daysLeft: Int) -> Color {
        switch daysLeft {
        case 0...7:   return .red
        case 8...30:  return .yellow
        default:      return .green
        }
    }
}

private func progressColor(daysLeft: Int) -> Color {
    switch daysLeft {
    case 0...7:   return .red
    case 8...30:  return .yellow
    default:      return .green
    }
}

// Preview provider
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
