import Foundation

struct CategoryBreakdown: Identifiable {
    var id: NoiseCategory { category }
    var category: NoiseCategory
    var duration: TimeInterval
}

/// One day's row in the recap card's "heat grid" — the app's stand-in for Strava's
/// route map: a strip of waking-hour ticks, solid where the phone was left alone.
struct HeatDay: Identifiable {
    let id = UUID()
    var label: String
    var awayTicks: [Bool]
}

struct WeekSummary {
    var weekStart: Date
    var weekEnd: Date

    var noiseByCategory: [CategoryBreakdown]
    var disconnectedWakingSeconds: TimeInterval
    var wakingSeconds: TimeInterval

    var percentileQuieterThan: Int
    var rankLabel: String
    var longestStretchSeconds: TimeInterval
    var streakWeeks: Int
    var deltaVsLastWeekPercent: Int

    var heatGrid: [HeatDay]

    var kudosCount: Int
    var kudosGiven: Bool

    var totalNoiseSeconds: TimeInterval {
        noiseByCategory.reduce(0) { $0 + $1.duration }
    }

    var disconnectedFraction: Double {
        wakingSeconds > 0 ? disconnectedWakingSeconds / wakingSeconds : 0
    }

    var weekRangeLabel: String {
        "\(weekStart.shortDateString)\u{2013}\(weekEnd.shortDateString)"
    }
}
