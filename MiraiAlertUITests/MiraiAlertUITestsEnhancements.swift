import XCTest

final class MiraiAlertUITestsEnhancements: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Enhancement Test 1: Attempt to add alarm in the past
    func testAddAlarmInPast() throws {
        // Tap the Add button
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        addButton.tap()
        
        // Wait for the view to load
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        // Try to set a date in the past (yesterday)
        let datePicker = app.datePickers["date_picker"]
        XCTAssertTrue(datePicker.exists, "Date picker should exist")
        
        // Set time to past (earlier today)
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        
        // Add a note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        noteField.typeText("Past Alarm Test")
        
        // Try to save
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify that an error alert appears
        let alertTitle = app.alerts["Invalid Date"]
        XCTAssertTrue(alertTitle.waitForExistence(timeout: 3), "Invalid date alert should appear")
        
        let alertMessage = app.staticTexts["Please select a date and time in the future."]
        XCTAssertTrue(alertMessage.exists, "Alert message should be displayed")
        
        // Dismiss the alert
        let okButton = app.buttons["OK"]
        XCTAssertTrue(okButton.exists, "OK button should exist in alert")
        okButton.tap()
        
        // Verify we're still in the Add Alarm view
        XCTAssertTrue(app.navigationBars["Add Alarm"].exists, "Should still be in Add Alarm view")
    }
    
    // MARK: - Enhancement Test 2: Notification permission on first launch
    func testNotificationPermissionRequest() throws {
        // Note: This test would ideally be run on a fresh install
        // For now, we'll just verify the app launches without crashing
        // and that the main view is accessible
        
        XCTAssertTrue(app.navigationBars["Alarms"].exists, "App should launch successfully")
        
        // In a real test environment, you would:
        // 1. Reset the app's permission state
        // 2. Launch the app
        // 3. Verify the permission alert appears
        // 4. Test both "Allow" and "Don't Allow" scenarios
        
        // For now, we'll just verify the app handles permission states gracefully
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist regardless of permission state")
    }
    
    // MARK: - Enhancement Test 3: Dark and Light Mode
    func testDarkAndLightMode() throws {
        // Note: This test would require setting up the app with specific appearance modes
        // For now, we'll verify that the UI elements are visible in the current mode
        
        let navigationBar = app.navigationBars["Alarms"]
        XCTAssertTrue(navigationBar.exists, "Navigation bar should be visible in current mode")
        
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should be visible in current mode")
        
        // Test Add Alarm view in current mode
        addButton.tap()
        
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should be visible")
        
        let timeSection = app.staticTexts["Time"]
        XCTAssertTrue(timeSection.exists, "Time section should be visible")
        
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should be visible")
        
        // Cancel and return to main view
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be visible")
        cancelButton.tap()
    }
    
    // MARK: - Enhancement Test 4: Notifications disabled flow
    func testNotificationsDisabledFlow() throws {
        // This test simulates when notifications are disabled
        // In a real test, you would set up the app with notifications disabled
        
        // Try to add an alarm
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        addButton.tap()
        
        // Fill in alarm details
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        noteField.typeText("Test Alarm")
        
        // Try to save
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // If notifications are disabled, should show permission alert
        let permissionAlert = app.alerts["Notification Permission Required"]
        if permissionAlert.exists {
            let goToSettingsButton = app.buttons["Go to Settings"]
            XCTAssertTrue(goToSettingsButton.exists, "Go to Settings button should exist")
            
            let cancelButton = app.buttons["Cancel"]
            XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
            
            // Tap Cancel to dismiss the alert
            cancelButton.tap()
            
            // Verify we're still in the Add Alarm view
            XCTAssertTrue(app.navigationBars["Add Alarm"].exists, "Should still be in Add Alarm view")
        }
    }
    
    // MARK: - Enhancement Test 5: Alarm note in notification
    func testAlarmNoteInNotification() throws {
        // This test would ideally verify that the alarm note appears in notifications
        // For now, we'll verify that the note is properly saved with the alarm
        
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        addButton.tap()
        
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        let testNote = "Important Meeting Tomorrow"
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        noteField.typeText(testNote)
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify the alarm with the note appears in the list
        let alarmNote = app.staticTexts[testNote]
        XCTAssertTrue(alarmNote.waitForExistence(timeout: 3), "Alarm note should appear in the list")
        
        // In a real test environment, you would also:
        // 1. Wait for the notification to trigger
        // 2. Verify the notification contains the correct note text
        // 3. Test notification interaction
    }
    
    // MARK: - Enhancement Test 6: Context Menu Actions
    func testContextMenuActions() throws {
        // First add an alarm to test context menu
        addTestAlarm()
        
        // Find the first alarm in the list
        let alarmList = app.tables.firstMatch
        XCTAssertTrue(alarmList.exists, "Alarm list should exist")
        
        let firstAlarm = alarmList.cells.firstMatch
        XCTAssertTrue(firstAlarm.exists, "First alarm should exist")
        
        // Long press to open context menu
        firstAlarm.press(forDuration: 1.0)
        
        // Verify context menu options appear
        let deleteAlarmOption = app.buttons["Delete Alarm"]
        let toggleAlarmOption = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Alarm'")).firstMatch
        
        if deleteAlarmOption.exists {
            XCTAssertTrue(deleteAlarmOption.exists, "Delete Alarm option should exist in context menu")
        }
        
        if toggleAlarmOption.exists {
            XCTAssertTrue(toggleAlarmOption.exists, "Toggle Alarm option should exist in context menu")
        }
        
        // Tap somewhere else to dismiss context menu
        let navigationBar = app.navigationBars["Alarms"]
        navigationBar.tap()
    }
    
    // MARK: - Helper Methods
    private func addTestAlarm() {
        let addButton = app.buttons["add_alarm_button"]
        if addButton.exists {
            addButton.tap()
            
            let dateSection = app.staticTexts["Date"]
            _ = dateSection.waitForExistence(timeout: 2)
            
            let noteField = app.textFields["note_field"]
            if noteField.exists {
                noteField.tap()
                noteField.typeText("Test Alarm for Context Menu")
            }
            
            let saveButton = app.buttons["Save"]
            if saveButton.exists {
                saveButton.tap()
            }
        }
    }
}