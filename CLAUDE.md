# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MiraiAlert is a SwiftUI iOS application built with Xcode 16.4 targeting iOS 18.5+. The app uses Core Data for local persistence and follows standard SwiftUI architecture patterns.

## Development Commands

### Building and Running
- **Build the project**: Open `MiraiAlert.xcodeproj` in Xcode and use Cmd+B to build
- **Run the app**: Use Cmd+R in Xcode to run on simulator or device
- **Clean build**: Use Cmd+Shift+K to clean build folder

### Testing
- **Run tests**: Use Cmd+U in Xcode to run test suite
- Currently no test files exist in the project

## Architecture

### Core Components
- **MiraiAlertApp.swift**: Main app entry point using `@main` attribute
- **ContentView.swift**: Primary view with Core Data integration for displaying items
- **Persistence.swift**: Core Data stack management with singleton pattern
- **MiraiAlert.xcdatamodeld**: Core Data model defining `Item` entity with timestamp

### Key Patterns
- Uses SwiftUI's `@Environment` for Core Data context injection
- Implements `@FetchRequest` for reactive data binding
- Standard Core Data CRUD operations with proper error handling
- Uses `PersistenceController.shared` singleton for data management

### Data Model
- Single `Item` entity with optional `timestamp` attribute (Date type)
- Configured for local storage (not using CloudKit)
- Uses automatic Core Data class generation

## Project Configuration
- **Bundle ID**: wenhan.blog.MiraiAlert
- **Development Team**: HFTAJ3MHZ2
- **Swift Version**: 5.0
- **Deployment Target**: iOS 18.5
- **Device Support**: iPhone and iPad (Universal)
- **Code Signing**: Automatic

## File Structure
```
MiraiAlert/
├── MiraiAlert.xcodeproj/     # Xcode project configuration
└── MiraiAlert/               # Source code
    ├── Assets.xcassets/      # App icons and assets
    ├── ContentView.swift     # Main UI view
    ├── MiraiAlertApp.swift   # App entry point
    ├── Persistence.swift     # Core Data stack
    └── MiraiAlert.xcdatamodeld/ # Core Data model
```

## Development Notes
- No external dependencies or package managers used
- Standard iOS app structure with SwiftUI and Core Data
- Error handling uses `fatalError()` for development (should be improved for production)
- Uses file system synchronized groups in Xcode project