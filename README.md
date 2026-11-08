# Irin

A macOS menu bar watcher that keeps your Mac awake for exactly as long as you choose: `caffeinate`, but native, visible, and with every option in plain sight.

## What it does

- Keeps your Mac awake for a preset time, a custom duration, or until a time of day you pick.
- Keeps the display lit as well, when you ask it to.
- Stops on its own when the battery falls below 20 %, when you ask it to.

## Why I built it

When a long download, build or render has to finish, `caffeinate` in a terminal works, but you can't see it and it's easy to forget. The menu bar apps that do the same tend to hide their options in nested menus and Option-clicks. Irin opens one large panel, centred under the menu bar, with every choice visible and labelled plainly. It is made for the moment you need it: rare, brief, often late and tired. One click on a preset and the Mac stays awake; the panel shows how long, until when, and how much is left.

## Built with

<!-- quieta:built-with -->
- SwiftUI
- AppKit
- CoreGraphics
- IOKit
- Observation
<!-- /quieta:built-with -->

## Requirements

<!-- quieta:requirements -->
- macOS 26.0 or later
- Xcode 26 to build from source
<!-- /quieta:requirements -->

Irin is not sandboxed and is not distributed through the Mac App Store; it is built from this repository.

## Getting started

<!-- quieta:getting-started -->
1. Clone the repository.
2. Open `Irin.xcodeproj` in Xcode.
3. Press ⌘R.
<!-- /quieta:getting-started -->

Irin lives only in the menu bar (no Dock icon). Click the eye to open the panel; click elsewhere or press Esc to close it.

**Launch at login.** Irin does not register itself. To start it with your Mac, add it in **System Settings › General › Login Items**.

## Architecture

<!-- quieta:architecture -->
```text
Irin/
├── App/
├── DesignSystem/
├── Identity/
├── Interface/
│   ├── Components/
│   ├── Formatting/
│   └── Panel/
├── Power/
├── Preferences/
└── Session/
IrinTests/
```
<!-- /quieta:architecture -->

| Part | What it holds |
|---|---|
| `App` | The app delegate: the status item, the one `AwakeSession`, a one-second ticker for expiry and the battery guard. |
| `Session` | The logic: `AwakeSession`, end conditions (duration, until a date, indefinitely), custom time in quarter-hour steps, presets. |
| `Power` | IOKit power assertions behind the `KeepAwake` protocol, and the battery reading behind `BatteryReading`. |
| `Preferences` | `UserDefaults` keys and how they are applied to the session at launch. |
| `Identity` | Name, epithet, version, author, signature, and the Greek inscriptions. |
| `DesignSystem` | Tokens only: palette, typography, metrics, interaction. |
| `Interface` | The panel controller, the panel view, and its components, each with a `#Preview`. |

Some decisions worth knowing:

- **A panel, not a menu.** A borderless `NSPanel`, centred on the screen whose menu bar was clicked.
- **IOKit assertions, not a `caffeinate` process.** One assertion at a time: *prevent idle system sleep*, or *prevent idle display sleep* when the display should stay on (a lit display also holds the system).
- **A running session is not restored** after Irin quits or the Mac restarts.

## Testing

The logic is covered by unit tests in Swift Testing (⌘U): sessions, end conditions across midnight and daylight saving changes, custom time, formatting and preferences. Time, calendar and battery state are passed in as parameters, so the tests never depend on the clock.

The interface is checked by hand before each release:

- [ ] A preset starts watching with one click; the tile lights up.
- [ ] Another preset while watching switches directly.
- [ ] Custom time: For and Until switch modes; − and + step by 15 minutes and explain themselves on hover.
- [ ] Start becomes **Stop watching** while watching, and the field does not shift.
- [ ] Until a time earlier than now says "tomorrow".
- [ ] Reopening the panel later refreshes an Until time that has passed.
- [ ] *Display stays on* swaps the assertion while watching.
- [ ] *Stop below 20 % battery* stops watching on battery power and explains why.
- [ ] Every clickable element responds to hover and press.
- [ ] Esc, a click outside, and a second click on the eye all close the panel.
- [ ] The panel opens under the menu bar on the screen that was clicked.
- [ ] Quit ends the app; the eye leaves the menu bar.

## License

© 2026 oblivi0n-arch. All rights reserved.

This covers the source code, the app icon and all artwork and screenshots. None of it may be copied, changed or redistributed without written permission.
