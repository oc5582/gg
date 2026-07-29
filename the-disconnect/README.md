# The Disconnect

A social-status app: it tracks weekly time spent on social/streaming/video apps vs. time spent away from the phone, and turns the "away" number into a shareable brag card.

## What's here

`prototype/index.html` — a self-contained, interactive iOS-style prototype (mock data, no build step). Open it directly in a browser. Screens:

- **Home** — this week's noise-app time (donut breakdown by category) vs. disconnected time, plus a percentile stat.
- **Recap** — the shareable "brag card" (Wrapped-style) with a share row.
- **Trends** — 8-week history bar chart with a table-view fallback, streak, and an insight callout.
- **Settings** — which apps count as "noise," weekly report schedule, Screen Time connection status.

## Known constraint for the real build

iOS's Screen Time API (`DeviceActivityReport`/`Family Controls`) keeps exact per-app numbers inside a sandboxed report extension for privacy — an app can't freely pull raw minutes into its own code to repackage elsewhere. Apps like Opal and One Sec work around this by rendering their branded UI *inside* the permitted report extension and sharing from there. The native build needs to follow that same pattern rather than reading screen-time numbers directly.

## Next steps

1. Review the prototype, flag what to change.
2. Native SwiftUI build (requires Xcode/macOS — not available in this environment) wiring up real `DeviceActivityReport` data in place of the mock numbers.
