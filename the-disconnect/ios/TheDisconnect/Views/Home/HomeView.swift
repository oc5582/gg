import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var model: AppModel

    private var week: WeekSummary { model.weekSummary }
    private var maxCategorySeconds: TimeInterval {
        week.noiseByCategory.map(\.duration).max() ?? 1
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(eyebrow: "Week of \(week.weekRangeLabel)", title: "This week")

                // Hero: noise time
                VStack(alignment: .leading, spacing: 3) {
                    Text("TIME ON NOISE APPS")
                        .font(Theme.mono(10.5))
                        .tracking(0.5)
                        .foregroundColor(Theme.ink3)
                    Text(week.totalNoiseSeconds.hoursMinutesString)
                        .font(Theme.serif(38, weight: .semibold))
                        .foregroundColor(Theme.ink)
                    Text("\(week.deltaVsLastWeekPercent < 0 ? "\u{2193}" : "\u{2191}") \(week.deltaVsLastWeekPercent < 0 ? "down" : "up") \(abs(week.deltaVsLastWeekPercent))% from last week")
                        .font(Theme.serif(13).italic())
                        .foregroundColor(Theme.ink2)
                }
                .padding(.bottom, 14)

                VStack(spacing: 10) {
                    ForEach(week.noiseByCategory) { row in
                        LedgerRow(
                            label: row.category.label,
                            value: row.duration.hoursMinutesString,
                            fraction: row.duration / maxCategorySeconds
                        )
                    }
                }

                SectionLabel("Disconnected")
                VStack(alignment: .leading, spacing: 3) {
                    Text("PHONE-FREE, WAKING HOURS")
                        .font(Theme.mono(10.5))
                        .tracking(0.5)
                        .foregroundColor(Theme.ink3)
                    Text(week.disconnectedWakingSeconds.hoursMinutesString)
                        .font(Theme.serif(38, weight: .semibold))
                        .foregroundColor(Theme.accent)
                }

                NoteQuote(
                    Text("\(Int((week.disconnectedFraction * 100).rounded()))% of your waking hours").bold()
                        + Text(" this week were spent away from your phone entirely.")
                )
                NoteQuote(
                    Text("Quieter than ") + Text("\(week.percentileQuieterThan)% of Disconnect users").bold() + Text(" this week.")
                )

                SectionLabel("Today's sessions")
                VStack(spacing: 0) {
                    ForEach(model.sessions) { session in
                        SessionRowView(session: session) {
                            model.toggleSessionKudos(session.id)
                        }
                        if session.id != model.sessions.last?.id {
                            Divider().overlay(Theme.ruleSoft)
                        }
                    }
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Theme.page)
    }
}

#Preview {
    HomeView().environmentObject(AppModel())
}
