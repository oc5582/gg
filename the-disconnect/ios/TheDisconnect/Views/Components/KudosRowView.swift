import SwiftUI

/// The tap-to-cheer row shown on the recap card: a nod count plus a Cheer/Cheered button.
struct KudosRowView: View {
    let count: Int
    let given: Bool
    var bold: Bool = false
    let onToggle: () -> Void

    private var foreground: Color { bold ? Theme.cream : Theme.ink }
    private var mutedForeground: Color { bold ? Color.white.opacity(0.6) : Theme.ink3 }
    private var dividerColor: Color { bold ? Color.white.opacity(0.3) : Theme.rule }

    var body: some View {
        VStack(spacing: 0) {
            Divider().overlay(dividerColor).padding(.bottom, 14)
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle().stroke(foreground, lineWidth: 1.5).frame(width: 20, height: 20)
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(foreground)
                    }
                    Text("\(count)")
                        .font(Theme.grotesk(14))
                        .foregroundColor(foreground)
                    Text("nods from friends")
                        .font(Theme.mono(10))
                        .foregroundColor(mutedForeground)
                }

                Spacer()

                Button(action: onToggle) {
                    Text(given ? "Cheered" : "Cheer")
                        .font(Theme.mono(10, weight: .semibold))
                        .tracking(0.5)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .foregroundColor(given ? (bold ? Theme.accent : Theme.page) : foreground)
                        .background(given ? foreground : Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 0).stroke(foreground, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
