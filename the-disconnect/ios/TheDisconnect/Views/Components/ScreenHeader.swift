import SwiftUI

/// The masthead-style header used at the top of every tab: a small caps eyebrow, a
/// serif title, and a double hairline rule underneath.
struct ScreenHeader: View {
    let eyebrow: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(eyebrow.uppercased())
                .font(Theme.mono(10.5))
                .tracking(1)
                .foregroundColor(Theme.ink3)
            Text(title)
                .font(Theme.serif(25, weight: .semibold))
                .foregroundColor(Theme.ink)
            VStack(spacing: 3) {
                Rectangle().fill(Theme.ink).frame(height: 1)
                Rectangle().fill(Theme.rule).frame(height: 1)
            }
            .padding(.top, 6)
        }
        .padding(.bottom, 12)
    }
}

/// A left-rule pull-quote, used for the italic asides throughout the app.
struct NoteQuote: View {
    let text: Text

    init(_ text: Text) { self.text = text }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle().fill(Theme.rule).frame(width: 2)
                .padding(.trailing, 12)
            text
                .font(Theme.serif(14).italic())
                .foregroundColor(Theme.ink2)
                .lineSpacing(3)
        }
        .padding(.top, 12)
    }
}

/// A section label — small caps monospace, used above lists and blocks.
struct SectionLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text.uppercased())
            .font(Theme.mono(10.5))
            .tracking(1)
            .foregroundColor(Theme.ink3)
            .padding(.top, 22)
            .padding(.bottom, 8)
    }
}
