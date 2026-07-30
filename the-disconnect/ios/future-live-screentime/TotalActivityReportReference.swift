// REFERENCE ONLY — not part of the buildable Xcode project.
//
// This is the shape of a `DeviceActivityReportExtension` scene that computes total
// device activity and a category breakdown from Apple's Screen Time data, following the
// pattern Apple demonstrated in WWDC22 "Meet the Screen Time API." It is NOT wired into
// project.yml and will not affect the main app's build either way.
//
// To use: create a real "Device Activity Report Extension" target in Xcode (which
// generates correct target/Info.plist wiring for you), then use this file as the
// starting point for its report scene — verify method/property names against the SDK
// version Xcode has open, since this API has shifted across iOS releases and I have no
// way to compile-check it here.
//
// See README.md in this folder for the full setup path (App Group, capability, etc).

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    static let totalActivity = Self("totalActivity")
}

struct TotalActivityReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .totalActivity
    let content: (WeeklyTotals) -> TotalActivityView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> WeeklyTotals {
        var totalSeconds: TimeInterval = 0
        var byCategory: [String: TimeInterval] = [:]

        for await result in data {
            for await activitySegment in result.activitySegments {
                totalSeconds += activitySegment.totalActivityDuration

                for await categoryActivity in activitySegment.categories {
                    let name = categoryActivity.category.localizedDisplayName ?? "Other"
                    byCategory[name, default: 0] += categoryActivity.totalActivityDuration
                }
            }
        }

        return WeeklyTotals(totalSeconds: totalSeconds, byCategory: byCategory)
    }
}

struct WeeklyTotals {
    var totalSeconds: TimeInterval
    var byCategory: [String: TimeInterval]
}

struct TotalActivityView: View {
    let totals: WeeklyTotals

    var body: some View {
        // Write `totals` into the shared App Group container here so the main app can
        // read it (UserDefaults(suiteName:) or a shared file), e.g.:
        //
        // let defaults = UserDefaults(suiteName: "group.com.thedisconnect.app")
        // defaults?.set(totals.totalSeconds, forKey: "totalNoiseSeconds")
        //
        // The view body itself is what Screen Time actually displays if the user opens
        // this report directly; for our use it mainly exists to trigger the write above.
        Text("\(Int(totals.totalSeconds / 60)) minutes tracked")
    }
}

@main
struct TheDisconnectReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TotalActivityReport { totals in
            TotalActivityView(totals: totals)
        }
    }
}
