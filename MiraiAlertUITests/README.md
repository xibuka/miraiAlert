# MiraiAlert UI Tests

This directory contains comprehensive XCUITest automated UI tests for the MiraiAlert iOS app.

## Test Files

### Core Test Files
- **`FutureAlarmUITests.swift`** - Main UI test suite with core functionality tests
- **`MiraiAlertUITests.swift`** - Original basic UI test implementation
- **`MiraiAlertUITestsEnhancements.swift`** - Enhanced tests for edge cases and validation
- **`UITestHelpers.swift`** - Helper utilities and base classes for UI testing

### Configuration Files
- **`Info.plist`** - Bundle configuration for the UI test target
- **`README.md`** - This documentation file

## Test Coverage

### Core Tests (FutureAlarmUITests.swift)
1. **`testAddAlarm`** - Tests adding a new alarm with date, time, note, and sound selection
2. **`testEditAlarm`** - Tests editing an existing alarm and verifying changes
3. **`testDeleteAlarm`** - Tests deleting an alarm using swipe-to-delete functionality
4. **`testUISmokeTest`** - Comprehensive UI component validation and interaction testing
5. **`testEmptyState`** - Tests the empty state when no alarms exist
6. **`testMultipleAlarms`** - Tests behavior with multiple alarms and edit mode

### Enhancement Tests (MiraiAlertUITestsEnhancements.swift)
1. **`testAddAlarmInPast`** - Validates rejection of past dates/times
2. **`testNotificationPermissionRequest`** - Tests permission handling on first launch
3. **`testDarkAndLightMode`** - Tests UI visibility in different appearance modes
4. **`testNotificationsDisabledFlow`** - Tests behavior when notifications are disabled
5. **`testAlarmNoteInNotification`** - Validates alarm notes appear in notifications
6. **`testContextMenuActions`** - Tests context menu functionality

## Accessibility Identifiers

The following accessibility identifiers are used in the tests:

### Main Views
- `add_alarm_button` - Add alarm button in navigation bar
- `alarms_list` - Main alarm list table view

### Add/Edit Alarm View
- `date_picker` - Date selection picker (graphical style)
- `time_picker` - Time selection picker (wheel style)
- `note_field` - Text field for alarm notes
- `sound_picker` - Sound selection picker

### Standard UI Elements
- `Save` - Save button
- `Cancel` - Cancel button
- `Edit` - Edit button
- `Done` - Done button (in edit mode)
- `Delete` - Delete button

## Running the Tests

### Prerequisites
- Xcode 16.4 or later
- iOS 18.5+ Simulator or Device
- MiraiAlert app built and available

### Command Line
```bash
# Run all UI tests
xcodebuild test -scheme MiraiAlert -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:MiraiAlertUITests

# Run specific test class
xcodebuild test -scheme MiraiAlert -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:MiraiAlertUITests/FutureAlarmUITests

# Run specific test method
xcodebuild test -scheme MiraiAlert -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:MiraiAlertUITests/FutureAlarmUITests/testAddAlarm
```

### Xcode IDE
1. Open `MiraiAlert.xcodeproj`
2. Select the Test Navigator (⌘+6)
3. Right-click on `MiraiAlertUITests` and select "Run"
4. Or use the Play button next to individual test methods

## Test Design Principles

### Reliability
- Uses explicit waits with `waitForExistence(timeout:)`
- Includes accessibility identifiers for stable element selection
- Handles system alerts and permissions gracefully
- Implements proper test setup and teardown

### Maintainability
- Base class `UITestBase` provides common functionality
- Helper methods for common operations (creating alarms, navigation)
- Clear, descriptive test names and comments
- Modular test structure with separate enhancement tests

### Comprehensive Coverage
- Tests all major user flows
- Validates both success and error scenarios
- Checks UI component visibility and interactivity
- Tests edge cases and boundary conditions

## Best Practices

### Test Structure
- Each test is independent and can run in isolation
- Tests clean up after themselves
- Helper methods reduce code duplication
- Clear arrange-act-assert pattern

### Assertions
- Use descriptive assertion messages
- Verify both positive and negative conditions
- Check UI state changes after actions
- Validate data persistence and display

### Timing
- Use appropriate timeouts for different operations
- Wait for elements to be hittable, not just present
- Handle asynchronous operations properly
- Include idle time for UI animations

## Troubleshooting

### Common Issues
1. **Element not found** - Check accessibility identifiers match
2. **Timing issues** - Increase timeouts or add explicit waits
3. **Simulator state** - Reset simulator between test runs
4. **Permission dialogs** - Ensure proper system alert handling

### Debug Tips
1. Use `po app.debugDescription` to inspect UI hierarchy
2. Enable "Slow Animations" in Simulator for debugging
3. Add `sleep()` calls temporarily to observe test execution
4. Use Xcode's UI Recording feature to generate test code

## Future Enhancements

Potential improvements for the test suite:
- Network condition testing
- Localization testing
- Performance testing
- Accessibility testing
- Integration with CI/CD pipeline
- Screenshot comparison testing
- Test data management improvements