import SwiftUI

@main
struct TheDisconnectApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(model)
                .tint(Theme.ink)
                .preferredColorScheme(nil)
        }
    }
}
