import SwiftUI

/// The shareable recap card itself — used both for on-screen display and, via
/// `ImageRenderer`, to produce the image that gets shared out.
struct RecapCardView: View {
    let week: WeekSummary
    let bold: Bool
    let onToggleKudos: () -> Void

    private var cardBackground: Color { bold ? Theme.accent : Theme.page }
    private var mutedForeground: Color { bold ? Color.white.opacity(0.72) : Theme.ink3 }
    private var bignumColor: Color { bold ? Theme.cream : Theme.ink }

    var stats: [RecapStat] {
        [
            RecapStat(value: week.totalNoiseSeconds.hoursMinutesString, label: "Noise this week"),
            RecapStat(value: week.longestStretchSeconds.hoursMinutesString, label: "Longest stretch"),
            RecapStat(value: week.rankLabel, label: "Rank vs. friends"),
            RecapStat(value: "\(week.streakWeeks) weeks", label: "Streak")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 3) {
                Text("THE DISCONNECT")
                    .font(Theme.mono(10.5))
                    .tracking(2)
                    .foregroundColor(mutedForeground)
                Text("Week of \(week.weekRangeLabel)")
                    .font(Theme.mono(11))
                    .foregroundColor(mutedForeground)
            }
            .padding(.trailing, 78)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                StampBadge(rankLabel: week.rankLabel, bold: bold)
            }

            Text(week.disconnectedWakingSeconds.hoursMinutesString)
                .font(bold ? Theme.grotesk(42, weight: .heavy) : Theme.serif(42, weight: .semibold))
                .foregroundColor(bignumColor)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)

            Text("disconnected \u{2014} \(Int((week.disconnectedFraction * 100).rounded()))% of waking hours")
                .font(Theme.serif(13).italic())
                .foregroundColor(mutedForeground)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)

            HeatGridView(days: week.heatGrid, bold: bold)
                .padding(.top, 20)

            StatGridView(stats: stats, bold: bold)
                .padding(.top, 18)

            KudosRowView(count: week.kudosCount, given: week.kudosGiven, bold: bold, onToggle: onToggleKudos)
                .padding(.top, 20)
        }
        .padding(20)
        .background(cardBackground)
        .overlay(
            Rectangle().stroke(bold ? Color.clear : Theme.ink, lineWidth: 1)
        )
        .shadow(color: .black.opacity(bold ? 0.28 : 0), radius: 20, x: 0, y: 12)
    }
}

private struct StampBadge: View {
    let rankLabel: String
    let bold: Bool

    private var color: Color { bold ? Theme.cream : Theme.accent }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
                .foregroundColor(color)
            VStack(spacing: 1) {
                Text(rankLabel.uppercased())
                Text("QUIET")
            }
            .font(Theme.mono(8.5, weight: .bold))
            .foregroundColor(color)
            .multilineTextAlignment(.center)
        }
        .frame(width: 68, height: 68)
        .rotationEffect(.degrees(-10))
    }
}

#Preview {
    RecapCardView(week: MockData.weekSummary(), bold: true, onToggleKudos: {})
        .padding()
}
