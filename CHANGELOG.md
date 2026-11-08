# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-08

_The watcher with its own icon_

### Added

- **identity**
  - Add the app icon

## [0.4.0] - 2026-11-08

_Polish the panel with greek inscriptions, meanders and hover feedback_

### Added

- **interface**
  - Sign the panel with the author and version
  - Rebuild the footer with inscribed actions
  - Stop watching from the custom time field
  - Set the stop action apart from start
  - Move quit beside the signature in the footer
  - Add greek to the status line
  - Add a greek section header above the presets
  - Respond to hover and press on buttons
  - Respond to hover and press across the panel
  - Explain the step buttons on hover
  - Frame the panel with meander bands
  - Say tomorrow when watching ends after midnight

### Fixed

- **preferences**
  - Remove stray parenthesis from the battery label
- **interface**
  - Size the panel once instead of during layout
- **session**
  - Refresh a passed until time when the panel opens

## [0.3.0] - 2026-11-07

_Keep the display on and stop watching on low battery_

### Added

- **preferences**
  - Add display and low battery toggles
  - Explain when watching stopped on low battery

## [0.2.0] - 2026-11-07

_Watch for a custom duration or until a chosen time_

### Added

- **interface**
  - Add custom duration and end time to the panel

## [0.1.0] - 2026-11-07

_Keep mac awake with presets_

### Added

- **interface**
  - Add menu bar extra
  - Add centered panel under the notch
  - Open panel on the screen whose menu bar was clicked
  - Add presets, countdown and stop to the panel and reflect the watching state in the menu bar icon
- **power**
  - Add power assertion wrapper
  - Add keep awake protocol
- **session**
  - Add awake session with end conditions

### Other

- Initial Commit
