import Combine
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var weekSummary: WeekSummary = MockData.weekSummary()
    @Published var sessions: [DisconnectSession] = MockData.sessions()
    @Published var trendWeeks: [TrendWeek] = MockData.trendWeeks()
    @Published var leaderboard: [FriendRank] = MockData.leaderboard()
    @Published var trackedApps: [TrackedApp] = MockData.trackedApps()

    @Published var recapCardIsBold = true
    @Published var weeklyReportEnabled = true
    @Published var watermarkEnabled = true
    @Published var weeklyReportWeekday = 1 // Sunday
    @Published var weeklyReportHour = 18

    let authorizer = FamilyControlsAuthorizer()
    private let notificationScheduler = NotificationScheduler()
    private var cancellables = Set<AnyCancellable>()

    var screenTimeConnected: Bool { authorizer.isAuthorized }

    init() {
        // Forward the nested authorizer's own @Published changes so views observing
        // just `AppModel` re-render when Screen Time authorization state changes.
        authorizer.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    func connectScreenTime() async {
        await authorizer.requestAuthorization()
    }

    func toggleWeekKudos() {
        weekSummary.kudosGiven.toggle()
        weekSummary.kudosCount += weekSummary.kudosGiven ? 1 : -1
    }

    func toggleSessionKudos(_ id: DisconnectSession.ID) {
        guard let index = sessions.firstIndex(where: { $0.id == id }) else { return }
        sessions[index].kudosGiven.toggle()
        sessions[index].kudosCount += sessions[index].kudosGiven ? 1 : -1
    }

    func toggleFriendKudos(_ id: FriendRank.ID) {
        guard let index = leaderboard.firstIndex(where: { $0.id == id }) else { return }
        leaderboard[index].kudosGiven.toggle()
        leaderboard[index].kudosCount += leaderboard[index].kudosGiven ? 1 : -1
    }

    func setTracked(_ id: TrackedApp.ID, isTracked: Bool) {
        guard let index = trackedApps.firstIndex(where: { $0.id == id }) else { return }
        trackedApps[index].isTracked = isTracked
    }

    func updateWeeklyReportSchedule() async {
        guard weeklyReportEnabled else {
            notificationScheduler.cancelWeeklyRecap()
            return
        }
        let granted = await notificationScheduler.requestAuthorization()
        guard granted else { return }
        notificationScheduler.scheduleWeeklyRecap(weekday: weeklyReportWeekday, hour: weeklyReportHour, minute: 0)
    }
}
