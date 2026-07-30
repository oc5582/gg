import Foundation
import UserNotifications

/// Schedules the real local notification for the weekly recap reminder set in Settings.
final class NotificationScheduler {
    static let weeklyRecapIdentifier = "weekly-recap"

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    /// - Parameters:
    ///   - weekday: 1 = Sunday ... 7 = Saturday, matching `DateComponents.weekday`.
    func scheduleWeeklyRecap(weekday: Int = 1, hour: Int = 18, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.weeklyRecapIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Your week, disconnected"
        content.body = "This week's recap is ready — see how quiet you were."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Self.weeklyRecapIdentifier, content: content, trigger: trigger)
        center.add(request)
    }

    func cancelWeeklyRecap() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.weeklyRecapIdentifier])
    }
}
