import XCTest

final class MiraiAlertUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test 1: Add Alarm
    func testAddAlarm() throws {
        // Tap the Add button
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        addButton.tap()
        
        // Verify we're in the Add Alarm view
        XCTAssertTrue(app.navigationBars["Add Alarm"].exists, "Should be in Add Alarm view")
        
        // Wait for the view to load
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        // Select a date (3 days later)
        let datePicker = app.datePickers["date_picker"]
        XCTAssertTrue(datePicker.exists, "Date picker should exist")
        
        // Calculate date 3 days from now
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: 3, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let targetDateString = dateFormatter.string(from: futureDate)
        
        // Interact with date picker (SwiftUI date picker interaction)
        datePicker.tap()
        
        // Select time (07:30 AM)
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        timePicker.tap()
        
        // Type in note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        noteField.typeText("Test Alarm")
        
        // Select sound (Radar)
        let soundPicker = app.buttons["sound_picker"]
        XCTAssertTrue(soundPicker.exists, "Sound picker should exist")
        soundPicker.tap()
        
        // Find and tap Radar option
        let radarOption = app.buttons["Radar"]
        if radarOption.exists {
            radarOption.tap()
        }
        
        // Tap Save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify we're back in the main view
        XCTAssertTrue(app.navigationBars["Alarms"].exists, "Should be back in Alarms view")
        
        // Verify the new alarm appears in the list
        let alarmList = app.tables.firstMatch
        XCTAssertTrue(alarmList.exists, "Alarm list should exist")
        
        // Look for the alarm note in the list
        let alarmNote = app.staticTexts["Test Alarm"]
        XCTAssertTrue(alarmNote.waitForExistence(timeout: 3), "New alarm with note should appear in list")
    }
    
    // MARK: - Test 2: Edit Alarm
    func testEditAlarm() throws {
        // First, ensure we have at least one alarm by adding one
        addTestAlarm()
        
        // Tap on the first alarm in the list
        let alarmList = app.tables.firstMatch
        XCTAssertTrue(alarmList.exists, "Alarm list should exist")
        
        let firstAlarm = alarmList.cells.firstMatch
        XCTAssertTrue(firstAlarm.exists, "First alarm should exist")
        firstAlarm.tap()
        
        // Verify we're in the Edit Alarm view
        XCTAssertTrue(app.navigationBars["Add Alarm"].exists, "Should be in Add Alarm view")
        
        // Change the time
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        timePicker.tap()
        
        // Change the note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        noteField.tap()
        
        // Clear existing text and type new note
        noteField.doubleTap()
        noteField.typeText("Updated Alarm")
        
        // Tap Save button
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Verify we're back in the main view
        XCTAssertTrue(app.navigationBars["Alarms"].exists, "Should be back in Alarms view")
        
        // Verify the updated alarm appears in the list
        let updatedAlarmNote = app.staticTexts["Updated Alarm"]
        XCTAssertTrue(updatedAlarmNote.waitForExistence(timeout: 3), "Updated alarm note should appear in list")
    }
    
    // MARK: - Test 3: Delete Alarm
    func testDeleteAlarm() throws {
        // First, ensure we have at least one alarm by adding one
        addTestAlarm()
        
        // Enter edit mode
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "Edit button should exist")
        editButton.tap()
        
        // Find the first alarm and swipe left to delete
        let alarmList = app.tables.firstMatch
        XCTAssertTrue(alarmList.exists, "Alarm list should exist")
        
        let firstAlarm = alarmList.cells.firstMatch
        XCTAssertTrue(firstAlarm.exists, "First alarm should exist")
        
        // Swipe left on the alarm
        firstAlarm.swipeLeft()
        
        // Tap the Delete button
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2), "Delete button should appear")
        deleteButton.tap()
        
        // Verify the alarm is removed (or if it was the last one, "No Alarms" message appears)
        let noAlarmsMessage = app.staticTexts["No Alarms"]
        let alarmStillExists = firstAlarm.exists
        
        XCTAssertTrue(noAlarmsMessage.exists || !alarmStillExists, "Alarm should be deleted or no alarms message should appear")
    }
    
    // MARK: - Test 4: UI Smoke Test
    func testUISmokeTest() throws {
        // Verify main UI components are visible
        let navigationBar = app.navigationBars["Alarms"]
        XCTAssertTrue(navigationBar.exists, "Alarms navigation bar should exist")
        
        // Verify Add button exists
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        
        // Verify Edit button exists (might be hidden if no alarms)
        let editButton = app.buttons["Edit"]
        // Note: Edit button might not exist if there are no alarms
        
        // Test navigation to Add view
        addButton.tap()
        XCTAssertTrue(app.navigationBars["Add Alarm"].exists, "Should navigate to Add Alarm view")
        
        // Verify Add Alarm view components
        let dateSection = app.staticTexts["Date"]
        XCTAssertTrue(dateSection.waitForExistence(timeout: 2), "Date section should exist")
        
        let timeSection = app.staticTexts["Time"]
        XCTAssertTrue(timeSection.exists, "Time section should exist")
        
        let noteSection = app.staticTexts["Note"]
        XCTAssertTrue(noteSection.exists, "Note section should exist")
        
        let soundSection = app.staticTexts["Sound"]
        XCTAssertTrue(soundSection.exists, "Sound section should exist")
        
        // Verify date picker is interactive
        let datePicker = app.datePickers["date_picker"]
        XCTAssertTrue(datePicker.exists, "Date picker should exist")
        XCTAssertTrue(datePicker.isEnabled, "Date picker should be interactive")
        
        // Verify time picker is interactive
        let timePicker = app.datePickers["time_picker"]
        XCTAssertTrue(timePicker.exists, "Time picker should exist")
        XCTAssertTrue(timePicker.isEnabled, "Time picker should be interactive")
        
        // Verify note input is visible
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.exists, "Note field should exist")
        XCTAssertTrue(noteField.isEnabled, "Note field should be interactive")
        
        // Verify sound picker is interactive
        let soundPicker = app.buttons["sound_picker"]
        XCTAssertTrue(soundPicker.exists, "Sound picker should exist")
        XCTAssertTrue(soundPicker.isEnabled, "Sound picker should be interactive")
        
        // Verify Save button exists
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        
        // Verify Cancel button exists
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
        
        // Test Save button triggers view dismissal
        cancelButton.tap()
        XCTAssertTrue(app.navigationBars["Alarms"].exists, "Should return to Alarms view")
    }
    
    // MARK: - Helper Methods
    private func addTestAlarm() {
        let addButton = app.buttons["add_alarm_button"]
        if addButton.exists {
            addButton.tap()
            
            // Wait for view to load
            let dateSection = app.staticTexts["Date"]
            _ = dateSection.waitForExistence(timeout: 2)
            
            // Add a simple test alarm
            let noteField = app.textFields["note_field"]
            if noteField.exists {
                noteField.tap()
                noteField.typeText("Test Alarm for Editing")
            }
            
            let saveButton = app.buttons["Save"]
            if saveButton.exists {
                saveButton.tap()
            }
        }
    }
}