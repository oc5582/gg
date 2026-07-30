import SwiftUI

struct RecapStat: Identifiable {
    let id = UUID()
    let value: String
    let label: String
}

/// The Strava-style 2x2 metric-tile grid: Duration / Longest Stretch / Rank / Streak.
struct StatGridView: View {
    let stats: [RecapStat]
    var bold: Bool = false

    private var numColor: Color { bold ? Theme.cream : Theme.ink }
    private var labelColor: Color { bold ? Color.white.opacity(0.6) : Theme.ink3 }

    private let columns = [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .leading)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(stats) { stat in
                VStack(alignment: .leading, spacing: 2) {
                    Text(stat.value)
                        .font(Theme.grotesk(19))
                        .foregroundColor(numColor)
                    Text(stat.label.uppercased())
                        .font(Theme.mono(9.5))
                        .tracking(0.5)
                        .foregroundColor(labelColor)
                }
            }
        }
    }
}
