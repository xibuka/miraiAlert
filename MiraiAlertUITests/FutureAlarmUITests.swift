import XCTest

final class FutureAlarmUITests: UITestBase {
    
    override func setUp() {
        super.setUp()
        launchApp()
    }
    
    // MARK: - Test 1: Add Alarm
    func testAddAlarm() throws {
        // Clean slate - delete any existing alarms
        deleteAllAlarms()
        
        // Navigate to Add Alarm view
        navigateToAddAlarm()
        
        // Verify date picker exists and is interactive
        let datePicker = app.datePickers["date_picker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 2), "Date picker should exist")
        XCTAssertTrue(datePicker.isEnabled, "Date picker should be interactive")
        
        // Verify time picker exists and is interactive
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        XCTAssertTrue(timePicker.isEnabled, "Time picker should be interactive")
        
        // Enter alarm note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        noteField.typeText("Test Alarm")
        
        // Select sound (Radar)
        let soundPicker = app.buttons["sound_picker"]
        XCTAssertTrue(soundPicker.exists, "Sound picker should exist")
        soundPicker.tap()
        
        // Try to find and select Radar option
        let radarOption = app.buttons["Radar"]
        if radarOption.exists {
            radarOption.tap()
        }
        
        // Save the alarm
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify we're back in the main view
        let alarmsNavBar = app.navigationBars["Alarms"]
        XCTAssertTrue(alarmsNavBar.waitForExistence(timeout: 3), "Should return to Alarms view")
        
        // Verify the new alarm appears in the list
        assertAlarmExists(note: "Test Alarm")
    }
    
    // MARK: - Test 2: Edit Alarm
    func testEditAlarm() throws {
        // Ensure we have a test alarm to edit
        createTestAlarm(note: "Original Alarm")
        
        // Find and tap on the alarm to edit it
        let alarmsList = app.tables["alarms_list"]
        if !alarmsList.exists {
            // Fallback to first match table
            let fallbackList = app.tables.firstMatch
            XCTAssertTrue(fallbackList.exists, "Alarm list should exist")
            
            let firstAlarm = fallbackList.cells.firstMatch
            XCTAssertTrue(firstAlarm.waitForExistence(timeout: 2), "First alarm should exist")
            firstAlarm.tap()
        } else {
            let firstAlarm = alarmsList.cells.firstMatch
            XCTAssertTrue(firstAlarm.waitForExistence(timeout: 2), "First alarm should exist")
            firstAlarm.tap()
        }
        
        // Verify we're in the edit view
        let addAlarmNavBar = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmNavBar.waitForExistence(timeout: 3), "Should be in Add Alarm view")
        
        // Update the note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        
        // Clear existing text and type new note
        noteField.doubleTap() // Select all
        noteField.typeText("Updated Alarm")
        
        // Save the changes
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify we're back in the main view
        let alarmsNavBar = app.navigationBars["Alarms"]
        XCTAssertTrue(alarmsNavBar.waitForExistence(timeout: 3), "Should return to Alarms view")
        
        // Verify the updated alarm appears in the list
        assertAlarmExists(note: "Updated Alarm")
        assertAlarmDoesNotExist(note: "Original Alarm")
    }
    
    // MARK: - Test 3: Delete Alarm
    func testDeleteAlarm() throws {
        // Create a test alarm to delete
        createTestAlarm(note: "Alarm to Delete")
        
        // Verify alarm exists
        assertAlarmExists(note: "Alarm to Delete")
        
        // Enter edit mode
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "Edit button should exist")
        editButton.tap()
        
        // Find the alarm and swipe left to delete
        let alarmsList = app.tables.firstMatch
        XCTAssertTrue(alarmsList.exists, "Alarm list should exist")
        
        let targetAlarm = alarmsList.cells.containing(.staticText, identifier: "Alarm to Delete").firstMatch
        if targetAlarm.exists {
            targetAlarm.swipeLeft()
        } else {
            // Fallback: delete first alarm
            let firstAlarm = alarmsList.cells.firstMatch
            XCTAssertTrue(firstAlarm.exists, "First alarm should exist")
            firstAlarm.swipeLeft()
        }
        
        // Tap delete button
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2), "Delete button should appear")
        deleteButton.tap()
        
        // Exit edit mode
        let doneButton = app.buttons["Done"]
        if doneButton.exists {
            doneButton.tap()
        }
        
        // Verify the alarm is deleted
        assertAlarmDoesNotExist(note: "Alarm to Delete")
    }
    
    // MARK: - Test 4: UI Smoke Test
    func testUISmokeTest() throws {
        // Verify main screen components
        let navigationBar = app.navigationBars["Alarms"]
        XCTAssertTrue(navigationBar.exists, "Alarms navigation bar should exist")
        
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        XCTAssertTrue(addButton.isEnabled, "Add button should be enabled")
        
        // Test navigation to Add Alarm view
        addButton.tap()
        
        // Verify Add Alarm view components
        let addAlarmNavBar = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmNavBar.waitForExistence(timeout: 3), "Should navigate to Add Alarm view")
        
        // Verify all sections are present
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        let timeSection = app.staticTexts["Time"]
        XCTAssertTrue(timeSection.exists, "Time section should exist")
        
        let noteSection = app.staticTexts["Note"]
        XCTAssertTrue(noteSection.exists, "Note section should exist")
        
        let soundSection = app.staticTexts["Sound"]
        XCTAssertTrue(soundSection.exists, "Sound section should exist")
        
        // Verify interactive elements
        let datePicker = app.datePickers["date_picker"]
        XCTAssertTrue(datePicker.exists, "Date picker should exist")
        XCTAssertTrue(datePicker.isEnabled, "Date picker should be interactive")
        
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        XCTAssertTrue(timePicker.isEnabled, "Time picker should be interactive")
        
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        XCTAssertTrue(noteField.isEnabled, "Note field should be interactive")
        
        let soundPicker = app.buttons["sound_picker"]
        XCTAssertTrue(soundPicker.exists, "Sound picker should exist")
        XCTAssertTrue(soundPicker.isEnabled, "Sound picker should be interactive")
        
        // Verify buttons
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        XCTAssertTrue(saveButton.isEnabled, "Save button should be enabled")
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
        XCTAssertTrue(cancelButton.isEnabled, "Cancel button should be enabled")
        
        // Test date picker interaction
        datePicker.tap()
        app.waitForIdle()
        
        // Test time picker interaction
        timePicker.tap()
        app.waitForIdle()
        
        // Test note field interaction
        noteField.tap()
        noteField.typeText("Smoke Test")
        XCTAssertEqual(noteField.value as? String, "Smoke Test", "Note field should accept text input")
        
        // Test sound picker interaction
        soundPicker.tap()
        app.waitForIdle()
        
        // Test cancel button dismisses view
        cancelButton.tap()
        XCTAssertTrue(app.navigationBars["Alarms"].waitForExistence(timeout: 3), "Should return to Alarms view")
    }
    
    // MARK: - Test 5: Empty State
    func testEmptyState() throws {
        // Delete all alarms to test empty state
        deleteAllAlarms()
        
        // Verify empty state message
        let noAlarmsMessage = app.staticTexts["No Alarms"]
        XCTAssertTrue(noAlarmsMessage.exists, "Empty state message should be visible")
        
        let emptyStateDescription = app.staticTexts["Add an alarm to get started"]
        XCTAssertTrue(emptyStateDescription.exists, "Empty state description should be visible")
        
        // Verify Edit button is not visible when no alarms
        let editButton = app.buttons["Edit"]
        XCTAssertFalse(editButton.exists, "Edit button should not be visible when no alarms exist")
        
        // Verify Add button still works
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should still exist")
        XCTAssertTrue(addButton.isEnabled, "Add button should still be enabled")
    }
    
    // MARK: - Test 6: Multiple Alarms
    func testMultipleAlarms() throws {
        // Clean slate
        deleteAllAlarms()
        
        // Create multiple alarms
        createTestAlarm(note: "First Alarm")
        createTestAlarm(note: "Second Alarm")
        createTestAlarm(note: "Third Alarm")
        
        // Verify all alarms exist
        assertAlarmExists(note: "First Alarm")
        assertAlarmExists(note: "Second Alarm")
        assertAlarmExists(note: "Third Alarm")
        
        // Verify Edit button appears when alarms exist
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "Edit button should exist when alarms are present")
        
        // Test edit mode
        editButton.tap()
        
        // Verify Done button appears
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2), "Done button should appear in edit mode")
        
        // Exit edit mode
        doneButton.tap()
        
        // Verify we're back to normal mode
        XCTAssertTrue(editButton.exists, "Edit button should reappear after exiting edit mode")
    }
}