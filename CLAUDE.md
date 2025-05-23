# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build and Run
```bash
# Build the project
xcodebuild -project Omni.xcodeproj -scheme Omni build

# Run the app (requires Xcode)
open Omni.xcodeproj
# Then use Cmd+R in Xcode
```

### Testing
```bash
# Run unit tests
xcodebuild test -project Omni.xcodeproj -scheme Omni -destination 'platform=macOS'

# Run UI tests
xcodebuild test -project Omni.xcodeproj -scheme OmniUITests -destination 'platform=macOS'
```

## Development Workflow

**IMPORTANT**: Always build the project using `xcodebuild` to verify compilation success before instructing the user to run the app. This ensures:
1. All syntax errors are caught
2. Dependencies are properly linked
3. The user has a working build

Example workflow:
1. Make code changes
2. Run: `xcodebuild -project Omni.xcodeproj -scheme Omni build`
3. Only after "BUILD SUCCEEDED" appears, tell the user to run the app

## Architecture

This is a Spotlight-like macOS application with a floating search window:

- **OmniApp.swift**: Entry point that registers global keyboard shortcut (Ctrl+Space)
- **SearchWindow.swift**: Main UI with glassmorphic floating window
- **SearchWindowManager.swift**: Manages window lifecycle and state
- **GlobalShortcut.swift**: Handles system-wide keyboard shortcut using Carbon APIs

The app uses:
- SwiftUI for modern macOS UI
- Carbon APIs for global keyboard shortcuts
- NSPanel for floating window behavior
- Visual effects for glassmorphic styling