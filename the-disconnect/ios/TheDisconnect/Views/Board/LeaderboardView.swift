import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject private var model: AppModel

    private var myRank: FriendRank? { model.leaderboard.first { $0.isMe } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(eyebrow: "Friends \u{00B7} this week", title: "Leaderboard")

                if let me = myRank {
                    Text("You're ")
                        .font(Theme.serif(13.5))
                        .foregroundColor(Theme.ink2)
                        + Text("#\(me.rank) of \(model.leaderboard.count)").bold().font(Theme.serif(13.5))
                        + Text(" friends \u{2014} ranked by phone-free waking hours. Higher is quieter.")
                            .font(Theme.serif(13.5))
                            .foregroundColor(Theme.ink2)
                }

                VStack(spacing: 0) {
                    ForEach(model.leaderboard) { friend in
                        LeaderboardRow(friend: friend) {
                            model.toggleFriendKudos(friend.id)
                        }
                        if !friend.isMe && friend.id != model.leaderboard.last?.id {
                            Divider().overlay(Theme.ruleSoft)
                        }
                    }
                }
                .padding(.top, 8)

                SectionLabel("Insight")
                NoteQuote(
                    Text("You've closed the gap to ").italic()
                        + Text("#3").bold()
                        + Text(" by ").italic()
                        + Text("2h 40m").bold()
                        + Text(" since last week \u{2014} one more quiet evening and you'll pass Wren.").italic()
                )

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Theme.page)
    }
}

private struct LeaderboardRow: View {
    let friend: FriendRank
    let onToggleKudos: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text("\(friend.rank)")
                .font(Theme.grotesk(12.5))
                .foregroundColor(friend.isMe ? Theme.accent : Theme.ink3)
                .frame(width: 16, alignment: .leading)

            ZStack {
                Circle().stroke(friend.isMe ? Theme.accent : Theme.ink3, lineWidth: 1.5)
                Text(friend.initials)
                    .font(Theme.mono(9, weight: .semibold))
                    .foregroundColor(friend.isMe ? Theme.accent : Theme.ink2)
            }
            .frame(width: 28, height: 28)

            Text(friend.name)
                .font(Theme.serif(14, weight: friend.isMe ? .bold : .regular))
                .foregroundColor(Theme.ink)

            Spacer()

            Text(friend.hoursDisconnected.hoursMinutesString)
                .font(Theme.grotesk(13))
                .foregroundColor(Theme.ink)

            if friend.isMe {
                Text("THIS\nWEEK")
                    .font(Theme.mono(8))
                    .foregroundColor(Theme.accent)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 26)
            } else {
                Button(action: onToggleKudos) {
                    ZStack {
                        Circle().stroke(friend.kudosGiven ? Theme.accent : Theme.rule, lineWidth: 1.5)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(friend.kudosGiven ? Theme.accent : Theme.ink3)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 11)
        .padding(.horizontal, friend.isMe ? 12 : 0)
        .background(friend.isMe ? Theme.accentSoft : Color.clear)
    }
}

#Preview {
    LeaderboardView().environmentObject(AppModel())
}
