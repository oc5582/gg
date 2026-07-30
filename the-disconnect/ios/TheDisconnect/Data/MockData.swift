import Foundation

/// Mock data that stands in for real Screen Time numbers until `AppModel` is wired to a
/// live provider (see `future-live-screentime/`). Dates are computed relative to "now" so
/// the app always reads as current, rather than pinned to whatever date this was written.
enum MockData {
    static let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2 // Monday
        return cal
    }()

    static func todayAt(_ hour: Int, _ minute: Int) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    static var currentWeekInterval: DateInterval {
        calendar.dateInterval(of: .weekOfYear, for: Date())
            ?? DateInterval(start: Date(), duration: 7 * 86400)
    }

    static func weekSummary() -> WeekSummary {
        let interval = currentWeekInterval
        let weekEnd = calendar.date(byAdding: .second, value: -1, to: interval.end) ?? interval.end

        return WeekSummary(
            weekStart: interval.start,
            weekEnd: weekEnd,
            noiseByCategory: [
                CategoryBreakdown(category: .social, duration: 5 * 3600 + 10 * 60),
                CategoryBreakdown(category: .streaming, duration: 2 * 3600 + 15 * 60),
                CategoryBreakdown(category: .video, duration: 1 * 3600 + 50 * 60),
                CategoryBreakdown(category: .other, duration: 27 * 60)
            ],
            disconnectedWakingSeconds: 89 * 3600 + 30 * 60,
            wakingSeconds: 112 * 3600,
            percentileQuieterThan: 82,
            rankLabel: "Top 12%",
            longestStretchSeconds: 14 * 3600 + 20 * 60,
            streakWeeks: 4,
            deltaVsLastWeekPercent: -18,
            heatGrid: heatGrid(),
            kudosCount: 128,
            kudosGiven: false
        )
    }

    /// 7 days x 16 waking-hour ticks (7am–10pm). true = away from phone.
    static func heatGrid() -> [HeatDay] {
        let patterns: [(String, String)] = [
            ("M", "1111111011111111"),
            ("T", "1111111111101111"),
            ("W", "1111101111111111"),
            ("T", "1111111111111101"),
            ("F", "1110111111110111"),
            ("S", "1111111111111111"),
            ("S", "1111111111011111")
        ]
        return patterns.map { label, pattern in
            HeatDay(label: label, awayTicks: pattern.map { $0 == "1" })
        }
    }

    static func sessions() -> [DisconnectSession] {
        [
            DisconnectSession(
                name: "Morning Reset",
                start: todayAt(6, 30),
                end: todayAt(9, 40),
                kudosCount: 12
            ),
            DisconnectSession(
                name: "Deep Work Block",
                start: todayAt(13, 0),
                end: todayAt(15, 15),
                kudosCount: 8
            ),
            DisconnectSession(
                name: "Evening Walk",
                start: todayAt(19, 0),
                end: todayAt(20, 5),
                kudosCount: 15
            )
        ]
    }

    static func trendWeeks() -> [TrendWeek] {
        let hours: [Double] = [16.2, 15.1, 14.0, 13.2, 12.0, 11.1, 10.5, 9.7]
        let lastIndex = hours.count - 1
        return hours.enumerated().map { index, value in
            let offset = -(lastIndex - index)
            let weekStart = calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeekInterval.start) ?? Date()
            return TrendWeek(
                weekStart: weekStart,
                shortLabel: weekStart.shortDateString,
                noiseHours: value,
                isCurrent: index == lastIndex
            )
        }
    }

    static func leaderboard() -> [FriendRank] {
        [
            FriendRank(rank: 1, name: "Priya", initials: "PR", hoursDisconnected: 96 * 3600 + 10 * 60, isMe: false, kudosCount: 4, kudosGiven: false),
            FriendRank(rank: 2, name: "Marcus", initials: "MC", hoursDisconnected: 93 * 3600 + 45 * 60, isMe: false, kudosCount: 2, kudosGiven: false),
            FriendRank(rank: 3, name: "Wren", initials: "WR", hoursDisconnected: 91 * 3600 + 20 * 60, isMe: false, kudosCount: 7, kudosGiven: false),
            FriendRank(rank: 4, name: "You", initials: "YOU", hoursDisconnected: 89 * 3600 + 30 * 60, isMe: true, kudosCount: 0, kudosGiven: false),
            FriendRank(rank: 5, name: "Dev", initials: "DV", hoursDisconnected: 85 * 3600 + 5 * 60, isMe: false, kudosCount: 1, kudosGiven: false),
            FriendRank(rank: 6, name: "Alicia", initials: "AL", hoursDisconnected: 81 * 3600 + 40 * 60, isMe: false, kudosCount: 0, kudosGiven: false)
        ]
    }

    static func trackedApps() -> [TrackedApp] {
        [
            TrackedApp(name: "Instagram", category: .social, isTracked: true),
            TrackedApp(name: "TikTok", category: .social, isTracked: true),
            TrackedApp(name: "X", category: .social, isTracked: true),
            TrackedApp(name: "Facebook", category: .social, isTracked: false),
            TrackedApp(name: "Netflix", category: .streaming, isTracked: true),
            TrackedApp(name: "YouTube", category: .video, isTracked: true)
        ]
    }
}
