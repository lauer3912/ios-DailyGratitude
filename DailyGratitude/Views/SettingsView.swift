import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    @State private var morningReminder = true
    @State private var eveningReminder = false
    @State private var reminderTime = Date()
    @State private var showResetConfirmation = false
    @State private var hapticEnabled = true

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle(isOn: $themeManager.isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    .tint(Color(hex: "A78BFA"))
                }
                .listRowBackground(Color(hex: "1C1C1E"))

                Section("Notifications") {
                    Toggle(isOn: $morningReminder) {
                        Label("Morning Reminder", systemImage: "sunrise.fill")
                    }
                    .tint(Color(hex: "A78BFA"))

                    Toggle(isOn: $eveningReminder) {
                        Label("Evening Reminder", systemImage: "moon.stars.fill")
                    }
                    .tint(Color(hex: "A78BFA"))

                    if morningReminder || eveningReminder {
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                .listRowBackground(Color(hex: "1C1C1E"))

                Section("Feedback") {
                    Toggle(isOn: $hapticEnabled) {
                        Label("Haptic Feedback", systemImage: "waveform")
                    }
                    .tint(Color(hex: "A78BFA"))
                }
                .listRowBackground(Color(hex: "1C1C1E"))

                Section("Data") {
                    Button {
                        exportData()
                    } label: {
                        Label("Export All Data", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Label("Reset All Data", systemImage: "trash")
                    }
                }
                .listRowBackground(Color(hex: "1C1C1E"))

                Section("About") {
                    Link(destination: URL(string: "https://lauer3912.github.io/ios-DailyGratitude/docs/PrivacyPolicy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }

                    Link(destination: URL(string: "https://apps.apple.com")!) {
                        Label("Rate App", systemImage: "star.fill")
                    }

                    Link(destination: URL(string: "https://twitter.com/intent/tweet?text=Try%20DailyGratitude!")!) {
                        Label("Share App", systemImage: "square.and.arrow.up")
                    }

                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Color(hex: "9B9BAD"))
                    }
                }
                .listRowBackground(Color(hex: "1C1C1E"))
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "0F0F23"))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("Reset All Data?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dataManager.resetAllData()
                }
            } message: {
                Text("This will delete all your entries, challenges, and achievements. This action cannot be undone.")
            }
        }
    }

    private func exportData() {
        dataManager.exportEntries()
    }
}
