import SwiftUI

struct RecapView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.displayScale) private var displayScale
    @State private var shareImage: Image?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(eyebrow: "Shareable", title: "Your recap")

                Picker("Card style", selection: $model.recapCardIsBold) {
                    Text("Bold").tag(true)
                    Text("Quiet").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)

                RecapCardView(week: model.weekSummary, bold: model.recapCardIsBold) {
                    model.toggleWeekKudos()
                }

                SectionLabel("Share")
                Group {
                    if let shareImage {
                        ShareLink(
                            item: shareImage,
                            preview: SharePreview("Your Disconnect recap", image: shareImage)
                        ) {
                            Label("Share your recap", systemImage: "square.and.arrow.up")
                                .font(Theme.mono(12.5, weight: .semibold))
                        }
                        .foregroundColor(Theme.ink)
                    } else {
                        Label("Preparing image\u{2026}", systemImage: "square.and.arrow.up")
                            .font(Theme.mono(12.5, weight: .semibold))
                            .foregroundColor(Theme.ink3)
                    }
                }
                .padding(.vertical, 6)

                Text("Opens the standard iOS share sheet \u{2014} Instagram Stories, X, Messages, Save Image, and Copy are all available there automatically.")
                    .font(Theme.serif(12.5).italic())
                    .foregroundColor(Theme.ink3)
                    .padding(.top, 2)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Theme.page)
        .task(id: model.recapCardIsBold) {
            await renderShareImage()
        }
        .onChange(of: model.weekSummary.kudosCount) { _, _ in
            Task { await renderShareImage() }
        }
    }

    @MainActor
    private func renderShareImage() async {
        let card = RecapCardView(week: model.weekSummary, bold: model.recapCardIsBold) {}
            .frame(width: 320)
        let renderer = ImageRenderer(content: card)
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    RecapView().environmentObject(AppModel())
}
