import SwiftUI

/// The "table of contents" dot leader between a label and its value, e.g. "Social ..... 5h 10m".
struct DottedLeader: View {
    var color: Color = Theme.rule

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let y = geo.size.height / 2
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: geo.size.width, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [1, 3]))
            .foregroundColor(color)
        }
        .frame(height: 8)
    }
}
