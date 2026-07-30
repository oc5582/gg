import Foundation

extension TimeInterval {
    /// "9h 42m", "14h", or "27m" — matches the ledger/recap card formatting used throughout the app.
    var hoursMinutesString: String {
        let totalMinutes = Int((self / 60).rounded())
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        if h == 0 { return "\(m)m" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(String(format: "%02d", m))m"
    }

    var hours: Double { self / 3600 }
}

extension Date {
    /// "6:30 AM"
    var shortTimeString: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: self)
    }

    /// "Jul 20"
    var shortDateString: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f.string(from: self)
    }
}
