//
//  UpcomingGamesWidget.swift
//  UpcomingGamesWatch
//
//  Created by Parshva Shah on 11/4/24.
//

import CoreData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), games: [])
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let now = Date()
        completion(SimpleEntry(date: now, games: fetchGames(at: now)))
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let now = Date()
        let nextMidnight = nextRefreshDate(after: now)
        let followingMidnight = nextRefreshDate(after: nextMidnight)
        let entries = [
            SimpleEntry(date: now, games: fetchGames(at: now)),
            SimpleEntry(date: nextMidnight, games: fetchGames(at: nextMidnight))
        ]
        completion(Timeline(entries: entries, policy: .after(followingMidnight)))
    }

    private func fetchGames(at date: Date) -> [WidgetGame] {
        let context = GameDataProvider.shared.newContext
        let fetchRequest = NSFetchRequest<GameDataModel>(entityName: "GameDataModel")
        let startOfToday = Calendar.current.startOfDay(for: date)

        fetchRequest.predicate = NSPredicate(
            format: "isUpcoming == YES AND releaseDate >= %@",
            startOfToday as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: true)]
        fetchRequest.fetchLimit = 4

        var games: [WidgetGame] = []
        context.performAndWait {
            do {
                games = try context.fetch(fetchRequest).map {
                    WidgetGame(id: $0.id, name: $0.name, releaseDate: $0.releaseDate)
                }
            } catch {
                print("Error fetching upcoming games for widget: \(error)")
            }
        }
        return games
    }

    private func nextRefreshDate(after date: Date) -> Date {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .day, value: 1, to: startOfToday)
            ?? date.addingTimeInterval(24 * 60 * 60)
    }
}

struct WidgetGame: Identifiable {
    let id: Int
    let name: String
    let releaseDate: Date
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let games: [WidgetGame]
}

// MARK: - Palette

private enum WidgetPalette {
    /// Matches the app's accent color asset.
    static let accent = Color("AccentColor")
    static let background = Color.black
    static let surface = Color(red: 0.14, green: 0.14, blue: 0.15)
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.74, green: 0.74, blue: 0.77)
    static let soon = Color(red: 1.0, green: 0.45, blue: 0.42)
    static let approaching = Color(red: 1.0, green: 0.80, blue: 0.30)
    static let distant = Color(red: 0.42, green: 0.85, blue: 0.55)
}

// MARK: - Entry view

struct UpcomingGamesWidgetEntryView: View {
    let entry: Provider.Entry

    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            if entry.games.isEmpty {
                EmptyUpcomingView()
            } else if family == .systemSmall {
                SmallUpcomingView(entry: entry)
            } else {
                MediumUpcomingView(entry: entry)
            }
        }
        .containerBackground(WidgetPalette.background, for: .widget)
        .widgetURL(WidgetConstants.upcomingGamesDeepLink)
    }
}

private struct SmallUpcomingView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WidgetHeader(gameCount: entry.games.count)

            if let game = entry.games.first {
                HeroGameCard(game: game, referenceDate: entry.date)
            }
        }
    }
}

private struct MediumUpcomingView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WidgetHeader(gameCount: entry.games.count)

            if let nextGame = entry.games.first {
                if entry.games.count == 1 {
                    HeroGameCard(game: nextGame, referenceDate: entry.date)
                } else {
                    HStack(spacing: 10) {
                        HeroGameCard(game: nextGame, referenceDate: entry.date)
                            .frame(width: 132)

                        VStack(spacing: 6) {
                            ForEach(entry.games.dropFirst()) { game in
                                UpcomingGameRow(game: game, referenceDate: entry.date)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

// MARK: - Components

private struct WidgetHeader: View {
    let gameCount: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(WidgetPalette.primaryText)
                .frame(width: 22, height: 22)
                .background(WidgetPalette.accent, in: RoundedRectangle(cornerRadius: 6))

            Text("Up Next")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(WidgetPalette.primaryText)

            Spacer(minLength: 4)

            Text("\(gameCount)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(WidgetPalette.secondaryText)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            gameCount == 1 ? "Up Next, 1 game" : "Up Next, \(gameCount) games"
        )
    }
}

private struct HeroGameCard: View {
    let game: WidgetGame
    let referenceDate: Date

    private var timing: ReleaseTiming {
        ReleaseTiming(game: game, referenceDate: referenceDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(timing.statusLabel)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(timing.color)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(timing.primaryValue)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(WidgetPalette.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                if let unit = timing.unitLabel {
                    Text(unit)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(WidgetPalette.secondaryText)
                }
            }

            Spacer(minLength: 4)

            Text(game.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(WidgetPalette.primaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            Text(game.releaseDate, format: .dateTime.month(.abbreviated).day())
                .font(.system(size: 11))
                .foregroundStyle(WidgetPalette.secondaryText)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(WidgetPalette.surface, in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(game.name), \(timing.accessibilityLabel)")
    }
}

private struct UpcomingGameRow: View {
    let game: WidgetGame
    let referenceDate: Date

    private var timing: ReleaseTiming {
        ReleaseTiming(game: game, referenceDate: referenceDate)
    }

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(WidgetPalette.accent)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 1) {
                Text(game.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(WidgetPalette.primaryText)
                    .lineLimit(1)

                Text(game.releaseDate, format: .dateTime.month(.abbreviated).day())
                    .font(.system(size: 10))
                    .foregroundStyle(WidgetPalette.secondaryText)
            }

            Spacer(minLength: 4)

            Text(timing.compactValue)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(timing.color)
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 9)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(WidgetPalette.surface, in: RoundedRectangle(cornerRadius: 10))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(game.name), \(timing.accessibilityLabel)")
    }
}

private struct EmptyUpcomingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WidgetHeader(gameCount: 0)

            VStack(alignment: .leading, spacing: 6) {
                Text("No games tracked")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(WidgetPalette.primaryText)

                Text("Mark a game as upcoming to start the countdown.")
                    .font(.system(size: 12))
                    .foregroundStyle(WidgetPalette.secondaryText)
                    .lineLimit(3)
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(WidgetPalette.surface, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Release timing

private struct ReleaseTiming {
    let days: Int

    init(game: WidgetGame, referenceDate: Date) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: referenceDate)
        let releaseDate = calendar.startOfDay(for: game.releaseDate)
        days = max(0, calendar.dateComponents([.day], from: startDate, to: releaseDate).day ?? 0)
    }

    var statusLabel: String {
        switch days {
        case 0:
            return "Out today"
        case 1:
            return "Out tomorrow"
        default:
            return "Releasing in"
        }
    }

    var primaryValue: String {
        days == 0 ? "Today" : "\(days)"
    }

    var unitLabel: String? {
        switch days {
        case 0:
            return nil
        case 1:
            return "day"
        default:
            return "days"
        }
    }

    var compactValue: String {
        switch days {
        case 0:
            return "Today"
        case 1:
            return "1 day"
        default:
            return "\(days) days"
        }
    }

    var accessibilityLabel: String {
        switch days {
        case 0:
            return "releases today"
        case 1:
            return "releases tomorrow"
        default:
            return "releases in \(days) days"
        }
    }

    var color: Color {
        switch days {
        case 0...7:
            return WidgetPalette.soon
        case 8...30:
            return WidgetPalette.approaching
        default:
            return WidgetPalette.distant
        }
    }
}

// MARK: - Previews

struct UpcomingGamesWidget_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: WidgetGame.sampleGames
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small")

        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: WidgetGame.sampleGames
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Medium")

        UpcomingGamesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            games: []
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Empty")
    }
}

struct UpcomingGamesWidget: Widget {
    let kind = WidgetConstants.upcomingGamesKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UpcomingGamesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Games")
        .description("See your next game release at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private extension WidgetGame {
    static var sampleGames: [WidgetGame] {
        let calendar = Calendar.current
        let now = Date()
        return [
            WidgetGame(
                id: 1,
                name: "Final Fantasy XVI",
                releaseDate: calendar.date(byAdding: .day, value: 5, to: now) ?? now
            ),
            WidgetGame(
                id: 2,
                name: "Starfield",
                releaseDate: calendar.date(byAdding: .day, value: 18, to: now) ?? now
            ),
            WidgetGame(
                id: 3,
                name: "Spider-Man 2",
                releaseDate: calendar.date(byAdding: .day, value: 42, to: now) ?? now
            ),
            WidgetGame(
                id: 4,
                name: "Hades II",
                releaseDate: calendar.date(byAdding: .day, value: 75, to: now) ?? now
            )
        ]
    }
}
