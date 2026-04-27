import SwiftUI

struct JournalView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedFilter: MoodFilter = .all
    @State private var showCalendar = true

    enum MoodFilter: String, CaseIterable {
        case all = "All"
        case happy = "😊"
        case neutral = "😐"
        case sad = "😢"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                if showCalendar {
                    calendarView
                }

                entriesList
            }
            .background(Color(hex: "0F0F23").ignoresSafeArea())
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search entries...")
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MoodFilter.allCases, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedFilter == filter ? .white : Color(hex: "9B9BAD"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? Color(hex: "A78BFA") : Color(hex: "1C1C1E"))
                            .cornerRadius(20)
                    }
                }

                Button {
                    showCalendar.toggle()
                } label: {
                    Image(systemName: showCalendar ? "calendar" : "list.bullet")
                        .foregroundColor(Color(hex: "A78BFA"))
                        .padding(8)
                        .background(Color(hex: "1C1C1E"))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private var calendarView: some View {
        VStack {
            HStack {
                Text(currentMonth)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 16) {
                    Button { previousMonth() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "A78BFA"))
                    }
                    Button { nextMonth() } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(hex: "A78BFA"))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                }

                ForEach(daysInMonth, id: \.self) { day in
                    if day > 0 {
                        let hasEntry = dataManager.entries.contains { Calendar.current.isDate($0.date, inSameDayAs: dateForDay(day)) }
                        let mood = dataManager.entries.first { Calendar.current.isDate($0.date, inSameDayAs: dateForDay(day)) }?.mood

                        Circle()
                            .fill(moodColor(for: mood))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("\(day)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    } else {
                        Color.clear
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var entriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEntries, id: \.id) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRow(entry: entry)
                    }
                }
            }
            .padding()
        }
    }

    private var filteredEntries: [GratitudeEntry] {
        var result = dataManager.entries

        if selectedFilter != .all {
            let moodIndex = MoodFilter.allCases.firstIndex(of: selectedFilter) ?? 0
            result = result.filter { $0.mood == moodIndex }
        }

        if !searchText.isEmpty {
            result = result.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }

        return result.sorted { $0.date > $1.date }
    }

    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: dataManager.currentMonth)
    }

    private var daysInMonth: [Int] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: dataManager.currentMonth)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: dataManager.currentMonth))!
        let weekday = calendar.component(.weekday, from: firstDay)
        var days = Array(repeating: 0, count: weekday - 1)
        days.append(contentsOf: Array(range))
        return days
    }

    private func dateForDay(_ day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: dataManager.currentMonth)
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    private func moodColor(for mood: Int?) -> Color {
        guard let mood = mood else { return Color.clear }
        switch mood {
        case 4: return Color(hex: "34D399")
        case 3: return Color(hex: "A78BFA")
        case 2: return Color(hex: "F4A261")
        case 1: return Color(hex: "6B6B7B")
        default: return Color(hex: "4A4A5A")
        }
    }

    private func previousMonth() {
        dataManager.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: dataManager.currentMonth) ?? Date()
    }

    private func nextMonth() {
        dataManager.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: dataManager.currentMonth) ?? Date()
    }
}

struct EntryRow: View {
    let entry: GratitudeEntry

    var body: some View {
        HStack(spacing: 12) {
            Text(moodEmoji)
                .font(.title)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.text.prefix(50) + (entry.text.count > 50 ? "..." : ""))
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                    Text("\(entry.wordCount) words")
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "9B9BAD"))
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
        .cornerRadius(12)
    }

    private var moodEmoji: String {
        ["😢", "😕", "😐", "🙂", "😊"][entry.mood]
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: entry.date)
    }
}

struct EntryDetailView: View {
    let entry: GratitudeEntry
    @EnvironmentObject var dataManager: DataManager
    @State private var isEditing = false
    @State private var editedText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How I felt")
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                    Text(moodEmoji)
                        .font(.system(size: 60))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Gratitude Entry")
                        .font(.caption)
                        .foregroundColor(Color(hex: "9B9BAD"))
                    Text(entry.text)
                        .font(.body)
                        .foregroundColor(.white)
                }

                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9B9BAD"))
                        Text(formattedDate)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Words")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9B9BAD"))
                        Text("\(entry.wordCount)")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .background(Color(hex: "0F0F23").ignoresSafeArea())
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button { isEditing = true } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        dataManager.deleteEntry(entry)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(hex: "A78BFA"))
                }
            }
        }
        .alert("Edit Entry", isPresented: $isEditing) {
            TextField("Gratitude text", text: $editedText)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                dataManager.updateEntry(entry, newText: editedText)
            }
        }
        .onAppear {
            editedText = entry.text
        }
    }

    private var moodEmoji: String {
        ["😢", "😕", "😐", "🙂", "😊"][entry.mood]
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: entry.date)
    }
}
