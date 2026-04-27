import SwiftUI

struct StatsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPeriod: StatsPeriod = .week

    enum StatsPeriod: String, CaseIterable {
        case week = "7 Days"
        case month = "30 Days"
        case all = "All Time"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    periodSelector

                    streakOverviewCard

                    moodTrendCard

                    weeklyStatsCard

                    achievementsCard
                }
                .padding()
            }
            .background(Color(hex: "0F0F23").ignoresSafeArea())
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var periodSelector: some View {
        HStack(spacing: 12) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button {
                    selectedPeriod = period
                } label: {
                    Text(period.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedPeriod == period ? .white : Color(hex: "9B9BAD"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? Color(hex: "A78BFA") : Color(hex: "1C1C1E"))
                        .cornerRadius(20)
                }
            }
        }
    }

    private var streakOverviewCard: some View {
        HStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text("\(dataManager.currentStreak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                Text("Current Streak")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9B9BAD"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "1C1C1E"))
            .cornerRadius(16)

            VStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "F4A261"))
                Text("\(dataManager.longestStreak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                Text("Best Streak")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9B9BAD"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "1C1C1E"))
            .cornerRadius(16)
        }
    }

    private var moodTrendCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Trend")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 4) {
                ForEach(moodTrendData, id: \.day) { dayData in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(moodColor(dayData.avgMood))
                            .frame(width: 32, height: CGFloat(dayData.avgMood + 1) * 20)
                        Text(dayData.label)
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "9B9BAD"))
                    }
                }
            }
            .frame(height: 140, alignment: .bottom)

            HStack {
                Circle().fill(Color(hex: "34D399")).frame(width: 8, height: 8)
                Text("Great").font(.caption).foregroundColor(Color(hex: "9B9BAD"))
                Spacer()
                Circle().fill(Color(hex: "A78BFA")).frame(width: 8, height: 8)
                Text("Good").font(.caption).foregroundColor(Color(hex: "9B9BAD"))
                Spacer()
                Circle().fill(Color(hex: "F4A261")).frame(width: 8, height: 8)
                Text("Okay").font(.caption).foregroundColor(Color(hex: "9B9BAD"))
                Spacer()
                Circle().fill(Color(hex: "6B6B7B")).frame(width: 8, height: 8)
                Text("Low").font(.caption).foregroundColor(Color(hex: "9B9BAD"))
            }
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var weeklyStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatItem(title: "Total Entries", value: "\(dataManager.totalEntries)", icon: "book.fill")
                StatItem(title: "Total Gratitude", value: "\(dataManager.totalGratitudeItems)", icon: "heart.fill")
                StatItem(title: "This Week", value: "\(dataManager.entriesThisWeek)", icon: "calendar")
                StatItem(title: "Avg per Day", value: String(format: "%.1f", dataManager.averageEntriesPerDay), icon: "chart.line.uptrend.xyaxis")
            }
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var achievementsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                AchievementBadge(title: "First Entry", icon: "star.fill", isUnlocked: dataManager.totalEntries >= 1)
                AchievementBadge(title: "7 Day Streak", icon: "flame.fill", isUnlocked: dataManager.longestStreak >= 7)
                AchievementBadge(title: "30 Day Streak", icon: "flame.circle.fill", isUnlocked: dataManager.longestStreak >= 30)
                AchievementBadge(title: "100 Entries", icon: "book.circle.fill", isUnlocked: dataManager.totalEntries >= 100)
                AchievementBadge(title: "Early Bird", icon: "sunrise.fill", isUnlocked: dataManager.hasEarlyBirdEntry)
                AchievementBadge(title: "Night Owl", icon: "moon.stars.fill", isUnlocked: dataManager.hasNightOwlEntry)
            }
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var moodTrendData: [(day: String, avgMood: Int)] {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        return days.enumerated().map { (index, label) in
            let mood = dataManager.moodTrendForDay(index)
            return (day: label, avgMood: mood)
        }
    }

    private func moodColor(_ mood: Int) -> Color {
        switch mood {
        case 4: return Color(hex: "34D399")
        case 3: return Color(hex: "A78BFA")
        case 2: return Color(hex: "F4A261")
        case 1: return Color(hex: "6B6B7B")
        default: return Color(hex: "4A4A5A")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "A78BFA"))
                Spacer()
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "9B9BAD"))
        }
        .padding()
        .background(Color(hex: "0F0F23"))
        .cornerRadius(12)
    }
}

struct AchievementBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(isUnlocked ? Color(hex: "F4A261") : Color(hex: "4A4A5A"))
                .frame(width: 50, height: 50)
                .background(isUnlocked ? Color(hex: "F4A261").opacity(0.2) : Color(hex: "0F0F23"))
                .cornerRadius(12)

            Text(title)
                .font(.caption2)
                .foregroundColor(isUnlocked ? .white : Color(hex: "9B9BAD"))
                .multilineTextAlignment(.center)
        }
    }
}
