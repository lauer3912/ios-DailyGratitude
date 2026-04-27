import WidgetKit
import SwiftUI

struct DailyGratitudeWidgetEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let todayPrompt: String
    let hasEntryToday: Bool
}

struct DailyGratitudeWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyGratitudeWidgetEntry {
        DailyGratitudeWidgetEntry(date: Date(), streak: 7, todayPrompt: "What are you grateful for today?", hasEntryToday: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyGratitudeWidgetEntry) -> Void) {
        let entry = DailyGratitudeWidgetEntry(date: Date(), streak: 7, todayPrompt: "What are you grateful for today?", hasEntryToday: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyGratitudeWidgetEntry>) -> Void) {
        let streak = UserDefaults.standard.integer(forKey: "streak")
        let prompts = [
            "What made you smile today?",
            "Who are you grateful for?",
            "What small joy did you experience?",
            "What is something beautiful around you?"
        ]
        let prompt = prompts[Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1 % prompts.count]
        let entry = DailyGratitudeWidgetEntry(date: Date(), streak: streak, todayPrompt: prompt, hasEntryToday: false)

        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct DailyGratitudeWidgetEntryView: View {
    var entry: DailyGratitudeWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(hex: "A78BFA"))
                Text("DailyGratitude")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            Spacer()

            if entry.hasEntryToday {
                Label("Done for today!", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(Color(hex: "34D399"))
            } else {
                Text("\(entry.streak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                Text("Day Streak")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(entry.todayPrompt)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .containerBackground(Color(UIColor.systemBackground), for: .widget)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

@main
struct DailyGratitudeWidget: Widget {
    let kind: String = "DailyGratitudeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyGratitudeWidgetProvider()) { entry in
            DailyGratitudeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DailyGratitude")
        .description("Track your gratitude streak and daily prompt.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
