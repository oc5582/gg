import Foundation

/// A single disconnect "activity" — the Strava-feed equivalent of a run or ride.
struct DisconnectSession: Identifiable {
    let id: UUID
    var name: String
    var start: Date
    var end: Date
    var kudosCount: Int
    var kudosGiven: Bool

    init(id: UUID = UUID(), name: String, start: Date, end: Date, kudosCount: Int, kudosGiven: Bool = false) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
        self.kudosCount = kudosCount
        self.kudosGiven = kudosGiven
    }

    var duration: TimeInterval { end.timeIntervalSince(start) }

    var timeRangeLabel: String { "\(start.shortTimeString) \u{2013} \(end.shortTimeString)" }

    /// Where this session sits across a 24-hour day, as fractions (for the position strip).
    var dayStartFraction: Double {
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: start)
        return start.timeIntervalSince(midnight) / 86400
    }

    var dayDurationFraction: Double { duration / 86400 }
}
