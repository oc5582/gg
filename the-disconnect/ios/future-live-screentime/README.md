# Going from mock data to live Screen Time data

The app in `../TheDisconnect` runs entirely on realistic mock data by default, and
attempts one real API call: `AuthorizationCenter.requestAuthorization(for: .individual)`
from Apple's `FamilyControls` framework, wired up in
`TheDisconnect/Services/FamilyControlsAuthorizer.swift` and triggered by the
"Connect Screen Time" row in Settings.

That call is as far as this build goes on purpose. Reading real per-app numbers is a
separate, larger step that Apple deliberately makes harder: `DeviceActivityReport`
keeps exact usage data inside a sandboxed **app extension** for privacy — your main app
code is not allowed to read raw per-app minutes directly, even with authorization. Apps
like Opal and One Sec get around this by rendering their own branded UI *inside* that
extension, then sharing from there.

I did not wire this extension into the buildable project. Not because it's not needed —
it's the one thing standing between this app and real data — but because I have no way
to compile or test Swift in this environment (no macOS, no Xcode, no simulator). Getting
target wiring, entitlements, or a fast-moving corner of the SDK subtly wrong would risk
breaking the *entire* app's build, including all the parts (every screen, sharing,
notifications, the authorization call) that I'm confident are correct. I'd rather hand
you a smaller thing that definitely builds than a bigger thing that might not.

## The path to live data

1. In Xcode, select the `TheDisconnect` project → **File → New → Target** → search for
   **"Device Activity Report Extension"** (built into Xcode 14+). This generates a
   correctly-wired extension target for you — bundle identifier, `NSExtension` Info.plist
   entry, and embedding in the app target are all handled by the template, so none of
   that hand-wiring risk applies if you let Xcode generate it.
2. Add an **App Group** capability to both the main app target and the new extension
   target (Signing & Capabilities → + Capability → App Groups), same group ID on both,
   e.g. `group.com.thedisconnect.app`.
3. Add the **Family Controls** capability to the main app target (Signing & Capabilities
   → + Capability → Family Controls). This requires a paid Apple Developer Program
   account — it won't show up under a free personal-team signing identity.
4. Replace the extension's generated Swift file with `TotalActivityReportReference.swift`
   in this folder — it's the shape of the report scene (computing total duration and a
   per-category breakdown from `DeviceActivityResults`), written from Apple's documented
   pattern (WWDC22 "Meet the Screen Time API"). Treat it as a strong starting point, not
   a guaranteed drop-in — verify it against whatever SDK version Xcode has open, since
   this corner of the API has shifted across iOS releases.
5. Have the extension write its computed totals into the shared App Group container
   (`UserDefaults(suiteName: "group.com.thedisconnect.app")` is the simplest option), and
   add a `LiveScreenTimeProvider` in the main app that reads from there, falling back to
   `MockData` when nothing's been written yet (first launch, simulator, no authorization).
6. Swap `AppModel`'s mock initial values for a call into that provider.

## Why the leaderboard is still local-only

The friends leaderboard (`LeaderboardView`) uses the same `MockData` source as
everything else. A real one needs accounts, a server, and a way for friends to see each
other's numbers — a separate backend project, not something to bolt on inside a single
iOS app target. Worth scoping deliberately once the core app is on real device data.
