import SwiftUI

/// The recap card's signature graphic — our stand-in for Strava's route map: 7 days of
/// waking-hour ticks, solid where the phone was left alone.
struct HeatGridView: View {
    let days: [HeatDay]
    var bold: Bool = false

    private var labelColor: Color { bold ? Color.white.opacity(0.55) : Theme.ink3 }
    private var tickOffColor: Color { bold ? Color.white.opacity(0.16) : Theme.ruleSoft }
    private var tickOnColor: Color { bold ? Theme.cream : Theme.ink }
    private var tickBorderColor: Color { bold ? Color.white.opacity(0.3) : Theme.rule }

    var body: some View {
        VStack(spacing: 5) {
            ForEach(days) { day in
                HStack(spacing: 8) {
                    Text(day.label)
                        .font(Theme.mono(9.5))
                        .foregroundColor(labelColor)
                        .frame(width: 13, alignment: .leading)

                    HStack(spacing: 2) {
                        ForEach(day.awayTicks.indices, id: \.self) { i in
                            Rectangle()
                                .fill(day.awayTicks[i] ? tickOnColor : tickOffColor)
                                .overlay(Rectangle().stroke(tickBorderColor, lineWidth: 0.5))
                                .frame(height: 13)
                        }
                    }
                }
            }
        }
    }
}
