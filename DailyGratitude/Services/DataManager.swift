import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var entries: [GratitudeEntry] = []
    @Published var currentMonth: Date = Date()
    @Published var activeChallenge: Challenge?

    private let entriesKey = "gratitude_entries"
    private let challengeKey = "active_challenge"
    private let streakKey = "current_streak"
    private let longestStreakKey = "longest_streak"

    var currentStreak: Int {
        calculateCurrentStreak()
    }

    var longestStreak: Int {
        UserDefaults.standard.integer(forKey: longestStreakKey)
    }

    var totalEntries: Int {
        entries.count
    }

    var totalGratitudeItems: Int {
        entries.reduce(0) { $0 + $1.wordCount }
    }

    var entriesThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return entries.filter { $0.date >= weekAgo }.count
    }

    var averageEntriesPerDay: Double {
        guard !entries.isEmpty else { return 0 }
        let days = max(1, Calendar.current.dateComponents([.day], from: entries.last?.date ?? Date(), to: Date()).day ?? 1)
        return Double(entries.count) / Double(days)
    }

    var hasEarlyBirdEntry: Bool {
        entries.contains { Calendar.current.component(.hour, from: $0.date) < 9 }
    }

    var hasNightOwlEntry: Bool {
        entries.contains { Calendar.current.component(.hour, from: $0.date) >= 20 }
    }

    var completedChallenges: [Challenge] {
        [] // Would be stored in UserDefaults
    }

    var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }

    init() {
        loadEntries()
        loadChallenge()
    }

    func addEntry(_ entry: GratitudeEntry) {
        entries.append(entry)
        saveEntries()
        updateStreak()
        advanceChallenge()
    }

    func updateEntry(_ entry: GratitudeEntry, newText: String) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].text = newText
            saveEntries()
        }
    }

    func deleteEntry(_ entry: GratitudeEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }

    func startNewChallenge() {
        activeChallenge = Challenge()
        saveChallenge()
    }

    func moodTrendForDay(_ dayIndex: Int) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let targetDate = calendar.date(byAdding: .day, value: -(6 - dayIndex), to: today) else { return 2 }

        let dayEntries = entries.filter { calendar.isDate($0.date, inSameDayAs: targetDate) }
        guard !dayEntries.isEmpty else { return 2 }

        return Int(dayEntries.reduce(0) { $0 + $1.mood }) / dayEntries.count
    }

    func exportEntries() {
        let text = entries.map { "[\($0.date)] \($0.text)" }.joined(separator: "\n\n")
        UIPasteboard.general.string = text
    }

    func resetAllData() {
        entries.removeAll()
        activeChallenge = nil
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: longestStreakKey)
        saveEntries()
        saveChallenge()
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) {
            entries = decoded
        }
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }

    private func loadChallenge() {
        if let data = UserDefaults.standard.data(forKey: challengeKey),
           let decoded = try? JSONDecoder().decode(Challenge.self, from: data) {
            activeChallenge = decoded
        }
    }

    private func saveChallenge() {
        if let encoded = try? JSONEncoder().encode(activeChallenge) {
            UserDefaults.standard.set(encoded, forKey: challengeKey)
        }
    }

    private func updateStreak() {
        let streak = calculateCurrentStreak()
        UserDefaults.standard.set(streak, forKey: streakKey)
        if streak > longestStreak {
            UserDefaults.standard.set(streak, forKey: longestStreakKey)
        }
    }

    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = entries.sorted { $0.date > $1.date }

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        for entry in sortedEntries {
            let entryDate = calendar.startOfDay(for: entry.date)
            if entryDate == currentDate || entryDate == calendar.date(byAdding: .day, value: -1, to: currentDate) {
                if entryDate != currentDate {
                    streak += 1
                    currentDate = entryDate
                } else {
                    streak += 1
                }
            } else if entryDate < calendar.date(byAdding: .day, value: -1, to: currentDate)! {
                break
            }
        }

        return streak
    }

    private func advanceChallenge() {
        guard var challenge = activeChallenge else { return }
        let calendar = Calendar.current
        let daysSinceStart = calendar.dateComponents([.day], from: challenge.startDate, to: Date()).day ?? 0

        if daysSinceStart >= challenge.currentDay && challenge.currentDay <= 21 {
            challenge.currentDay = min(21, daysSinceStart + 1)
            if challenge.currentDay == 21 {
                challenge.completedDate = Date()
            }
            activeChallenge = challenge
            saveChallenge()
        }
    }
}
