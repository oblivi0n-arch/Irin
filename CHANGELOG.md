# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
