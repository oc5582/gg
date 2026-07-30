import Foundation

struct FriendRank: Identifiable {
    let id = UUID()
    var rank: Int
    var name: String
    var initials: String
    var hoursDisconnected: TimeInterval
    var isMe: Bool
    var kudosCount: Int
    var kudosGiven: Bool
}
