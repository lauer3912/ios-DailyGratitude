import Foundation

struct GratitudeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var text: String
    var mood: Int
    let wordCount: Int

    init(id: UUID = UUID(), date: Date = Date(), text: String, mood: Int, wordCount: Int) {
        self.id = id
        self.date = date
        self.text = text
        self.mood = mood
        self.wordCount = wordCount
    }
}

struct Challenge: Identifiable, Codable {
    let id: UUID
    let startDate: Date
    var currentDay: Int
    var completedDate: Date?

    init(id: UUID = UUID(), startDate: Date = Date()) {
        self.id = id
        self.startDate = startDate
        self.currentDay = 1
        self.completedDate = nil
    }

    var isCompleted: Bool {
        currentDay >= 21
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let icon: String
    let requirement: Int
    let type: AchievementType

    enum AchievementType {
        case entries
        case streak
        case challenge
        case special
    }
}
