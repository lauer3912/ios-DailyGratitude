import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showNewChallenge = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let activeChallenge = dataManager.activeChallenge {
                        activeChallengeCard(activeChallenge)
                    } else {
                        noActiveChallengeCard
                    }

                    challengePromptsSection

                    challengeHistorySection
                }
                .padding()
            }
            .background(Color(hex: "0F0F23").ignoresSafeArea())
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewChallenge = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "A78BFA"))
                    }
                }
            }
            .sheet(isPresented: $showNewChallenge) {
                NewChallengeSheet()
            }
        }
    }

    private func activeChallengeCard(_ challenge: Challenge) -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("21-Day Gratitude Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Started \(challenge.startDate.formatted(.dateTime.day().month()))")
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                }
                Spacer()
                Image(systemName: "flame.fill")
                    .font(.title)
                    .foregroundColor(.orange)
            }

            ProgressView(value: Double(challenge.currentDay), total: 21)
                .tint(Color(hex: "A78BFA"))

            HStack {
                ForEach(1...21, id: \.self) { day in
                    Circle()
                        .fill(day <= challenge.currentDay ? Color(hex: "A78BFA") : Color(hex: "4A4A5A"))
                        .frame(width: 12, height: 12)
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Day \(challenge.currentDay)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("of 21 completed")
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                }
                Spacer()
                Text("\(Int(Double(challenge.currentDay) / 21.0 * 100))%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "A78BFA"))
            }

            if challenge.currentDay == 7 || challenge.currentDay == 14 || challenge.currentDay == 21 {
                celebrationBanner
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [Color(hex: "2D1B69"), Color(hex: "1C1C1E")], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
    }

    private var celebrationBanner: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("Milestone reached! Keep going!")
                .foregroundColor(.white)
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "F4A261").opacity(0.2))
        .cornerRadius(12)
    }

    private var noActiveChallengeCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "flame")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "A78BFA"))

            Text("Start a 21-Day Challenge")
                .font(.headline)
                .foregroundColor(.white)

            Text("Build a gratitude habit that lasts")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9B9BAD"))
                .multilineTextAlignment(.center)

            Button {
                showNewChallenge = true
            } label: {
                Text("Begin Challenge")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C5CBF")], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
    }

    private var challengePromptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Challenge")
                .font(.headline)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                Text(challengePrompt)
                    .font(.body)
                    .foregroundColor(Color(hex: "9B9BAD"))
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(hex: "1C1C1E"))
            .cornerRadius(12)
        }
    }

    private var challengeHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Challenges")
                .font(.headline)
                .foregroundColor(.white)

            if dataManager.completedChallenges.isEmpty {
                Text("No completed challenges yet")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9B9BAD"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(dataManager.completedChallenges, id: \.id) { challenge in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "34D399"))
                        Text("21-Day Challenge")
                            .foregroundColor(.white)
                        Spacer()
                        Text(challenge.completedDate?.formatted(.dateTime.day().month().year()) ?? "")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9B9BAD"))
                    }
                    .padding()
                    .background(Color(hex: "1C1C1E"))
                    .cornerRadius(12)
                }
            }
        }
    }

    private var challengePrompt: String {
        let prompts = [
            "Write about someone who changed your life and why you're grateful for them.",
            "Describe a challenge you overcame and what it taught you about gratitude.",
            "List five things about your body you're grateful for.",
            "Write about a memory that always makes you smile.",
            "Think about your daily routine and find 3 things you usually take for granted."
        ]
        return prompts[dataManager.dayOfYear % prompts.count]
    }
}

struct NewChallengeSheet: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "A78BFA"))

                Text("Start 21-Day Challenge")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Complete daily gratitude entries for 21 days to build a lasting habit.")
                    .font(.body)
                    .foregroundColor(Color(hex: "9B9BAD"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    dataManager.startNewChallenge()
                    dismiss()
                } label: {
                    Text("Start Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C5CBF")], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 40)
            .background(Color(hex: "0F0F23").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "A78BFA"))
                }
            }
        }
    }
}
