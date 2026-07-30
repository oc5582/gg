import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            LeaderboardView()
                .tabItem { Label("Board", systemImage: "trophy") }

            RecapView()
                .tabItem { Label("Recap", systemImage: "square.and.arrow.up") }

            TrendsView()
                .tabItem { Label("Trends", systemImage: "chart.bar") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .background(Theme.page)
    }
}

#Preview {
    RootTabView().environmentObject(AppModel())
}
