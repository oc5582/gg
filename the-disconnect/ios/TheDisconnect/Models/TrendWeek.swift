import Foundation

struct TrendWeek: Identifiable {
    let id = UUID()
    var weekStart: Date
    var shortLabel: String
    var noiseHours: Double
    var isCurrent: Bool
}
