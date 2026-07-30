import Foundation

enum NoiseCategory: String, CaseIterable, Identifiable {
    case social, streaming, video, other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .social: return "Social"
        case .streaming: return "Streaming"
        case .video: return "YouTube"
        case .other: return "Other"
        }
    }
}
