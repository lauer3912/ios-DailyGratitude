# DailyGratitude - Specification Document

## 1. Project Overview

- **Project Name**: DailyGratitude
- **Bundle ID**: com.ggsheng.DailyGratitude
- **Core Functionality**: A mindfulness and gratitude journal app that helps users cultivate daily gratitude through structured journaling, 21-day challenges, mood tracking, and achievement systems.
- **Target Users**: Adults seeking mental wellness, meditation practitioners, journaling enthusiasts in Western markets
- **iOS Version Support**: iOS 17.0+
- **App Store Name**: DailyGratitude
- **Pricing**: $9.99 one-time purchase

---

## 2. UI/UX Specification

### Screen Structure

1. **HomeView** - Daily gratitude entry + streak display
2. **JournalView** - Browse past entries calendar/ list
3. **ChallengesView** - 21-day gratitude challenge tracker
4. **StatsView** - Mood trends + statistics
5. **SettingsView** - App settings + notifications

### Navigation Structure

- **TabView** with 5 tabs: Home, Journal, Challenges, Stats, Settings

### Visual Design

#### Color Palette
- **Primary**: #A78BFA (Soft Purple)
- **Secondary**: #7C5CBF (Deep Purple)
- **Accent**: #F4A261 (Warm Gold)
- **Background Dark**: #0F0F23
- **Surface Dark**: #1C1C1E
- **Text Primary Dark**: #FFFFFF
- **Text Secondary Dark**: #9B9BAD
- **Background Light**: #FAFAFA
- **Surface Light**: #FFFFFF
- **Text Primary Light**: #1A1A2E
- **Text Secondary Light**: #6B6B7B

#### Typography
- **Heading 1**: 28pt Bold, SF Pro
- **Heading 2**: 22pt Semibold, SF Pro
- **Body**: 16pt Regular, SF Pro
- **Caption**: 13pt Regular, SF Pro
- **Button**: 16pt Semibold, SF Pro

#### Spacing
- **Grid**: 8pt system
- **Padding Standard**: 16pt
- **Card Radius**: 16pt

---

## 3. Functionality Specification

### Core Features (70+)

#### Home Tab
1. Daily gratitude prompt with random question
2. Morning/Evening greeting based on time
3. Streak counter with flame animation
4. Today's mood selector (5 emoji scale)
5. Quick add gratitude entry
6. Daily inspirational quote
7. Progress ring showing weekly goal
8. Recent entries preview (last 3)
9. Daily reminder notification
10. Night mode auto-schedule

#### Journal Tab
11. Calendar view with mood colors
12. List view toggle
13. Entry search
14. Filter by mood
15. Filter by date range
16. Entry detail view
17. Edit past entries
18. Delete entries with confirmation
19. Export entries as text
20. Entry word count display

#### Challenges Tab
21. 21-Day Gratitude Challenge
22. Daily challenge prompt
23. Challenge progress tracker
24. Challenge completion celebration
25. Multiple simultaneous challenges
26. Challenge reminder notifications
27. Challenge streak protection
28. Restart challenge option
29. Challenge history archive
30. Milestone celebrations (Day 7, 14, 21)

#### Stats Tab
31. Mood trend line chart (7/30/90 days)
32. Weekly mood distribution pie chart
33. Total entries counter
34. Total gratitude items count
35. Current streak display
36. Longest streak record
37. Monthly heatmap calendar
38. Most common mood
39. Average entries per week
40. Consistency score percentage

#### Settings Tab
41. Dark/Light theme toggle
42. Notification time picker
43. Morning reminder (on/off)
44. Evening reminder (on/off)
45. Reminder quiet hours
46. App theme auto-schedule
47. Export all data
48. Import data backup
49. Privacy Policy display
50. Rate App link
51. Share App link
52. About/Version info
53. Reset all data (with confirmation)
54. Notification sound selection
55. Haptic feedback toggle

#### Achievements System
56. First Entry badge
57. 7-Day Streak badge
58. 30-Day Streak badge
59. 100 Entries badge
60. Early Bird (morning entry)
61. Night Owl (evening entry)
62. Mood Tracker (30 days mood log)
63. Challenge Completer (21-day)
64. Grateful Heart (1000 gratitude items)
65. Consistent Logger (30 days straight)

#### Widget
66. Small widget: Current streak + today's prompt
67. Medium widget: Streak + weekly progress ring
68. Lock screen widget: Streak count

#### Additional Features
69. Onboarding flow (3 screens)
70. First launch celebration
71. Daily quote push notification
72. Seasonal themes (auto)

---

## 4. Technical Specification

### Architecture
- **Pattern**: MVVM with SwiftUI
- **Minimum iOS**: 17.0
- **UI Framework**: SwiftUI
- **Widget**: WidgetKit with Timeline

### Dependencies
- None (pure SwiftUI + native frameworks)

### Data Storage
- **UserDefaults**: Settings, preferences
- **SQLite.swift**: Entries, moods, challenges (via raw SQLite)

### Asset Requirements
- App Icon: 1024x1024 (19 sizes generated)
- SF Symbols for all icons
- No custom fonts (SF Pro system)

### App Group
- `group.com.ggsheng.DailyGratitude` (for Widget data sharing)

---

## 5. Privacy & Compliance

- No user accounts required
- No data collected or shared
- All data stored locally on device
- Export feature for user data portability
- Privacy Policy URL required for App Store

---

## 6. Bundle IDs

- **Main App**: com.ggsheng.DailyGratitude
- **Widget**: com.ggsheng.DailyGratitude.widget
- **App Group**: group.com.ggsheng.DailyGratitude
