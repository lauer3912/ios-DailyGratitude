import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var gratitudeText = ""
    @State private var selectedMood: Int = 2
    @State private var showEntrySuccess = false

    private let moodEmojis = ["😢", "😕", "😐", "🙂", "😊"]
    private let prompts = [
        "What are three things you're grateful for today?",
        "Who made a positive impact on your day?",
        "What small joy did you experience recently?",
        "What is something you're looking forward to?",
        "What skill or ability are you thankful for?",
        "What made you smile today?",
        "What is something beautiful you noticed today?",
        "Who are you grateful to have in your life?"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    greetingHeader

                    streakCard

                    promptCard

                    moodSelector

                    entryCard

                    if showEntrySuccess {
                        successBanner
                    }
                }
                .padding()
            }
            .background(Color(hex: "0F0F23").ignoresSafeArea())
            .navigationTitle("Daily Gratitude")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(dateString)
                .font(.subheadline)
                .foregroundColor(Color(hex: "9B9BAD"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var streakCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(dataManager.currentStreak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                Text("Day Streak")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9B9BAD"))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(dataManager.longestStreak)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: "A78BFA"))
                Text("Best: \(dataManager.longestStreak) days")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9B9BAD"))
            }
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Color(hex: "F4A261"))
                Text("Today's Prompt")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Text(prompts[dataManager.dayOfYear % prompts.count])
                .font(.body)
                .foregroundColor(Color(hex: "9B9BAD"))
                .italic()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: "2D1B69"), Color(hex: "1C1C1E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }

    private var moodSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How are you feeling?")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { index in
                    Button {
                        selectedMood = index
                    } label: {
                        Text(moodEmojis[index])
                            .font(.system(size: index == selectedMood ? 36 : 28))
                            .opacity(index == selectedMood ? 1 : 0.5)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var entryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What are you grateful for?")
                .font(.headline)
                .foregroundColor(.white)

            TextEditor(text: $gratitudeText)
                .frame(height: 120)
                .padding(8)
                .background(Color(hex: "0F0F23"))
                .cornerRadius(12)
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)

            Button {
                saveEntry()
            } label: {
                Text("Save Entry")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Group {
                            if gratitudeText.isEmpty {
                                Color(hex: "4A4A5A")
                            } else {
                                LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C5CBF")], startPoint: .leading, endPoint: .trailing)
                            }
                        }
                    )
                    .cornerRadius(12)
            }
            .disabled(gratitudeText.isEmpty)
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var successBanner: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(hex: "34D399"))
            Text("Entry saved! Keep up the great work!")
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(12)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Good Morning"
        } else if hour < 17 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    private var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }

    private func saveEntry() {
        let entry = GratitudeEntry(
            id: UUID(),
            date: Date(),
            text: gratitudeText,
            mood: selectedMood,
            wordCount: gratitudeText.split(separator: " ").count
        )
        dataManager.addEntry(entry)
        gratitudeText = ""
        showEntrySuccess = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showEntrySuccess = false
        }
    }
}
