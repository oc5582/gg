# The Disconnect

A social-status app: it tracks weekly time spent on social/streaming/video apps vs. time spent away from the phone, and turns the "away" number into a shareable brag card — Strava's logic (a route-shaped signature graphic, a stat grid, kudos from friends) applied to going quiet instead of going for a run.

## What's here

- **`prototype/index.html`** — a self-contained, interactive iOS-style web prototype (mock data, no build step). Open it directly in a browser. Good for iterating on design fast.
- **`ios/`** — a real, buildable SwiftUI iOS app implementing the same design: five tabs (Home, Board, Recap, Trends, Settings), running on mock data by default, with genuine device functionality (share-sheet image export, local notifications, a real Screen Time authorization request). See `ios/README.md` to build and run it, and `ios/future-live-screentime/README.md` for what's mock vs. real and the path from one to the other.

## Screens (both versions)

- **Home** — this week's noise-app time (category breakdown ledger) vs. disconnected time, plus a percentile stat and a feed of today's individual "sessions."
- **Board** — friend leaderboard ranked by phone-free waking hours, with kudos.
- **Recap** — the shareable card: a Bold (Strava-style, full-color, screenshot-ready) or Quiet (diary-style) toggle, a weekly "signal strip" heat grid standing in for a route map, a stat grid, and kudos.
- **Trends** — 8-week history chart with a table-view fallback, streak, and an insight callout.
- **Settings** — which apps count as "noise," weekly report schedule, Screen Time connection status.

## Known constraint on real Screen Time data

iOS's Screen Time API (`DeviceActivityReport`/`Family Controls`) keeps exact per-app numbers inside a sandboxed report extension for privacy — an app can't freely pull raw minutes into its own code to repackage elsewhere. Apps like Opal and One Sec work around this by rendering their branded UI *inside* the permitted report extension and sharing from there. The native app's `AppModel` is structured to make this swap-in straightforward once that extension is wired up — see `ios/future-live-screentime/README.md`.

## Next steps

1. Open `ios/` in Xcode (see `ios/README.md`) and run it on a simulator or your iPhone.
2. Wire up live Screen Time data via the `DeviceActivityReport` extension path documented in `ios/future-live-screentime/`.
3. Real friends on the leaderboard need an account system + server — a separate project phase.
