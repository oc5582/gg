# The Disconnect — iOS app

A real SwiftUI app, not another mockup: five working tabs (Home, Board, Recap, Trends,
Settings), running on realistic mock data, with genuine device functionality wired in —
sharing, notifications, and a real Screen Time authorization request. See
`future-live-screentime/README.md` for exactly what's mock vs. real, and the path from
one to the other.

## Setup

This project ships as an [XcodeGen](https://github.com/yonaskolb/XcodeGen) spec
(`project.yml`) rather than a hand-committed `.xcodeproj`. XcodeGen reliably produces a
valid Xcode project from a small declarative file, which is a lot safer than a
hand-authored `.pbxproj` I have no way to compile-check from here — and it's the same
reason many real iOS teams use it, to avoid merge-conflict-prone project files.

```sh
brew install xcodegen
cd the-disconnect/ios
xcodegen generate
open TheDisconnect.xcodeproj
```

Then in Xcode: pick a simulator (or your iPhone), and Cmd+R.

If you'd rather not install XcodeGen: create a new Xcode project (App template, SwiftUI,
Swift, iOS 17+), then drag the contents of `TheDisconnect/` into it, replacing the
generated `ContentView.swift`/App file with the ones here.

## What's real vs. mock

**Real, working device functionality:**
- Full SwiftUI navigation across all 5 tabs
- Sharing the recap card as an actual image via the system share sheet
  (`ImageRenderer` + `ShareLink` — this is where Instagram Stories, X, Messages, Save
  Image, and Copy all come from automatically, no per-platform code needed)
- Scheduling the real weekly-recap local notification (`UNUserNotificationCenter`)
- Requesting real Screen Time authorization (`FamilyControls.AuthorizationCenter`) from
  the "Connect Screen Time" row in Settings
- Toggling which apps count as "noise," kudos/cheer state, and card style (Bold/Quiet) —
  all live in `AppModel` and drive the UI immediately

**Mock, by design, for now:**
- The actual weekly numbers (noise time, disconnected time, category breakdown, streaks,
  the heat grid) — `Data/MockData.swift`. Reading real per-app Screen Time numbers
  requires a `DeviceActivityReport` app extension, which Apple deliberately keeps
  separate for privacy. See `future-live-screentime/` for the reference implementation
  and exact setup steps — I left it unwired rather than risk breaking the whole build on
  a part of the SDK I can't test.
- The friends leaderboard — local data, no backend. Real friends need accounts and a
  server, which is its own project.

## Structure

```
TheDisconnect/
  App/              App entry point + AppModel (the shared environment object)
  Design/           Theme.swift — colors, serif/mono/grotesk font helpers
  Models/           WeekSummary, DisconnectSession, FriendRank, TrendWeek, TrackedApp
  Data/             MockData.swift — every mock value, computed relative to "now"
  Services/         FamilyControlsAuthorizer, NotificationScheduler
  Views/
    Components/     ScreenHeader, LedgerRow, HeatGridView, StatGridView, KudosRowView,
                     SessionRowView — shared building blocks
    Home/           This week's ledger + today's session feed
    Board/          Friend leaderboard
    Recap/          The shareable card + Bold/Quiet toggle + share sheet
    Trends/         Swift Charts bar chart + table fallback
    Settings/       Tracked apps, weekly report schedule, Screen Time connection
```

## Design system

Carried over 1:1 from the web prototype: an ink-on-paper, diary/ledger palette with one
restrained accent (a stamp-ink red), New York serif for headlines and narrative text,
system monospace for labels and data, and a bold SF Pro numeral face reserved for the
Strava-style stat tiles on the recap card. All of it is plain SwiftUI — no custom fonts
or asset catalog dependency, so there's nothing extra to import for this to render
correctly.
