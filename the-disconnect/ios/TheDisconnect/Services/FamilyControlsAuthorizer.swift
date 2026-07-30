import FamilyControls
import Foundation

/// Wraps Apple's Screen Time API authorization request. This compiles and runs on any
/// build — `import FamilyControls` and `AuthorizationCenter` don't require a special
/// entitlement to *call*, only to *succeed*. Without the "Family Controls" capability
/// added in Xcode's Signing & Capabilities (and a real device), this will throw and the
/// app falls back to showing mock data everywhere, same as before the call.
///
/// See `future-live-screentime/README.md` for the next step: reading real per-app
/// numbers via a `DeviceActivityReport` extension.
@MainActor
final class FamilyControlsAuthorizer: ObservableObject {
    @Published private(set) var isAuthorized = false
    @Published private(set) var lastErrorMessage: String?

    private let center = AuthorizationCenter.shared

    init() {
        isAuthorized = center.authorizationStatus == .approved
    }

    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            isAuthorized = center.authorizationStatus == .approved
            lastErrorMessage = nil
        } catch {
            isAuthorized = false
            lastErrorMessage = "Screen Time isn't available here — this needs a real device with the Family Controls capability enabled. Showing sample data instead."
        }
    }
}
