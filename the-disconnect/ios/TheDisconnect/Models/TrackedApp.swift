import Foundation

struct TrackedApp: Identifiable {
    let id = UUID()
    var name: String
    var category: NoiseCategory
    var isTracked: Bool
}
