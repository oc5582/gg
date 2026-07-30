import SwiftUI

/// One row in the Home "Today's sessions" feed — an individual disconnect activity,
/// echoing a Strava feed card: name, duration, a position-in-day strip, and kudos.
struct SessionRowView: View {
    let session: DisconnectSession
    let onToggleKudos: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .lastTextBaseline) {
                Text(session.name)
                    .font(Theme.serif(14.5, weight: .semibold))
                Spacer()
                Text(session.duration.hoursMinutesString)
                    .font(Theme.grotesk(14))
            }
            .foregroundColor(Theme.ink)

            Text(session.timeRangeLabel)
                .font(Theme.mono(10))
                .foregroundColor(Theme.ink3)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.ruleSoft)
                    Rectangle()
                        .fill(Theme.ink)
                        .frame(width: geo.size.width * session.dayDurationFraction)
                        .offset(x: geo.size.width * session.dayStartFraction)
                }
            }
            .frame(height: 6)

            HStack(spacing: 7) {
                Button(action: onToggleKudos) {
                    ZStack {
                        Circle()
                            .stroke(session.kudosGiven ? Theme.accent : Theme.rule, lineWidth: 1.5)
                            .frame(width: 21, height: 21)
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(session.kudosGiven ? Theme.accent : Theme.ink3)
                    }
                }
                .buttonStyle(.plain)

                Text("\(session.kudosCount) nods")
                    .font(Theme.mono(10.5))
                    .foregroundColor(Theme.ink2)
            }
        }
        .padding(.vertical, 13)
    }
}
