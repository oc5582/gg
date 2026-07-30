import SwiftUI

/// A single row of the category breakdown ledger: label, dotted leader, value, and a
/// thin monochrome magnitude bar underneath — the print-infographic stand-in for a
/// colored donut chart.
struct LedgerRow: View {
    let label: String
    let value: String
    let fraction: Double
    var bold: Bool = false

    private var labelColor: Color { bold ? Theme.cream : Theme.ink }
    private var valueColor: Color { bold ? Theme.cream.opacity(0.7) : Theme.ink2 }
    private var barTrackColor: Color { bold ? Color.white.opacity(0.16) : Theme.ruleSoft }
    private var barFillColor: Color { bold ? Theme.cream : Theme.ink3 }
    private var leaderColor: Color { bold ? Color.white.opacity(0.3) : Theme.rule }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(label)
                    .font(Theme.serif(14))
                    .foregroundColor(labelColor)
                    .fixedSize()
                DottedLeader(color: leaderColor)
                Text(value)
                    .font(Theme.mono(12.5))
                    .foregroundColor(valueColor)
                    .fixedSize()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(barTrackColor)
                    Rectangle().fill(barFillColor).frame(width: geo.size.width * max(0, min(1, fraction)))
                }
            }
            .frame(height: 2)
        }
    }
}
