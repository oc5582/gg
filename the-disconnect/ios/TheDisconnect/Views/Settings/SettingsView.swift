import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var model: AppModel
    @State private var isConnecting = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(eyebrow: "Configure", title: "Settings")

                screenTimeStatus

                SectionLabel("Tracked as \u{201C}noise\u{201D}")
                VStack(spacing: 0) {
                    ForEach(model.trackedApps) { app in
                        settingsRow(name: app.name, subtitle: app.category.label.uppercased()) {
                            Binding(
                                get: { app.isTracked },
                                set: { model.setTracked(app.id, isTracked: $0) }
                            )
                        }
                        if app.id != model.trackedApps.last?.id {
                            Divider().overlay(Theme.ruleSoft)
                        }
                    }
                }

                SectionLabel("Weekly report")
                VStack(spacing: 0) {
                    settingsRow(name: "Recap notifications", subtitle: "Sundays at 6:00 PM") {
                        $model.weeklyReportEnabled
                    }
                    Divider().overlay(Theme.ruleSoft)
                    settingsRow(name: "Include watermark on shares", subtitle: "Adds \u{201C}The Disconnect\u{201D} mark") {
                        $model.watermarkEnabled
                    }
                }
                .onChange(of: model.weeklyReportEnabled) { _, _ in
                    Task { await model.updateWeeklyReportSchedule() }
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Theme.page)
    }

    private var screenTimeStatus: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                guard !isConnecting else { return }
                isConnecting = true
                Task {
                    await model.connectScreenTime()
                    isConnecting = false
                }
            } label: {
                HStack(spacing: 7) {
                    Circle()
                        .fill(model.screenTimeConnected ? Theme.accent : Theme.ink3)
                        .frame(width: 5, height: 5)
                    Text(isConnecting ? "Connecting\u{2026}" : (model.screenTimeConnected ? "Screen Time connected" : "Connect Screen Time"))
                    Spacer()
                    if !model.screenTimeConnected && !isConnecting {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Theme.ink3)
                    }
                }
                .font(Theme.mono(11.5))
                .foregroundColor(Theme.ink2)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .disabled(model.screenTimeConnected)

            if let message = model.authorizer.lastErrorMessage {
                Text(message)
                    .font(Theme.serif(11.5).italic())
                    .foregroundColor(Theme.ink3)
                    .padding(.bottom, 10)
            }
        }
        .overlay(Rectangle().fill(Theme.rule).frame(height: 1), alignment: .bottom)
    }

    private func settingsRow(name: String, subtitle: String, isOn: @escaping () -> Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(name).font(Theme.serif(14.5)).foregroundColor(Theme.ink)
                Text(subtitle)
                    .font(Theme.mono(10))
                    .tracking(0.3)
                    .foregroundColor(Theme.ink3)
            }
            Spacer()
            Toggle("", isOn: isOn())
                .labelsHidden()
                .tint(Theme.ink)
        }
        .padding(.vertical, 11)
    }
}

#Preview {
    SettingsView().environmentObject(AppModel())
}
