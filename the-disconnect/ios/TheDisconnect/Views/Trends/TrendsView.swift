import Charts
import SwiftUI

struct TrendsView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showTable = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(eyebrow: "Last \(model.trendWeeks.count) weeks", title: "Trends")

                SectionLabel("Noise-app hours / week").padding(.top, 0)

                if showTable {
                    trendTable
                } else {
                    trendChart
                }

                Button(showTable ? "View as chart" : "View as table") {
                    withAnimation(.easeInOut(duration: 0.15)) { showTable.toggle() }
                }
                .font(Theme.mono(11.5, weight: .semibold))
                .foregroundColor(Theme.ink)
                .padding(.top, 10)

                SectionLabel("Streak")
                NoteQuote(
                    Text("\(model.weekSummary.streakWeeks)-week streak").bold()
                        + Text(" \u{2014} cutting noise-app time every week.").italic()
                )

                SectionLabel("Insight")
                NoteQuote(
                    Text("You've cut ").italic()
                        + Text("Social & Streaming").bold()
                        + Text(" time by ").italic()
                        + Text("34%").bold()
                        + Text(" over the last two months. At this pace you'll be under ").italic()
                        + Text("8h/week").bold()
                        + Text(" soon.").italic()
                )

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Theme.page)
    }

    private var trendChart: some View {
        Chart(model.trendWeeks) { week in
            BarMark(
                x: .value("Week", week.shortLabel),
                y: .value("Hours", week.noiseHours)
            )
            .foregroundStyle(week.isCurrent ? Theme.accent : Theme.rule)
            .cornerRadius(0)
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                    .font(Theme.mono(9))
                    .foregroundStyle(Theme.ink3)
            }
        }
        .frame(height: 130)
        .padding(.top, 4)
    }

    private var trendTable: some View {
        VStack(spacing: 0) {
            HStack {
                Text("WEEK OF").font(Theme.mono(10, weight: .semibold)).foregroundColor(Theme.ink3)
                Spacer()
                Text("HOURS").font(Theme.mono(10, weight: .semibold)).foregroundColor(Theme.ink3)
            }
            .padding(.bottom, 6)
            Divider().overlay(Theme.ruleSoft)

            ForEach(model.trendWeeks) { week in
                HStack {
                    Text(week.weekStart.shortDateString).font(Theme.serif(12.5))
                    Spacer()
                    Text(String(format: "%.1fh", week.noiseHours)).font(Theme.serif(12.5))
                }
                .foregroundColor(Theme.ink)
                .padding(.vertical, 7)
                Divider().overlay(Theme.ruleSoft)
            }
        }
        .padding(.top, 4)
    }
}

#Preview {
    TrendsView().environmentObject(AppModel())
}
