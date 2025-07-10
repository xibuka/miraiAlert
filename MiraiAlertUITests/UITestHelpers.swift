import XCTest

extension XCUIApplication {
    
    /// Waits for the app to be idle and responsive
    func waitForIdle() {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
    }
    
    /// Dismisses any system alerts that might appear
    func dismissSystemAlerts() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertAllowButton = springboard.buttons["Allow"]
        let alertDontAllowButton = springboard.buttons["Don't Allow"]
        let alertOKButton = springboard.buttons["OK"]
        
        if alertAllowButton.exists {
            alertAllowButton.tap()
        } else if alertDontAllowButton.exists {
            alertDontAllowButton.tap()
        } else if alertOKButton.exists {
            alertOKButton.tap()
        }
    }
    
    /// Resets the app state by clearing all data
    func resetAppState() {
        // This would typically involve clearing UserDefaults, CoreData, etc.
        // For this implementation, we'll use app launch arguments
        launchArguments.append("--uitesting")
        launchArguments.append("--reset-data")
    }
}

extension XCUIElement {
    
    /// Waits for element to exist and be hittable
    func waitForHittable(timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "exists == true AND hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    /// Clears text from a text field
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        // Select all text and delete it
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
    
    /// Types text after clearing existing text
    func typeTextAfterClear(_ text: String) {
        clearText()
        typeText(text)
    }
    
    /// Force taps an element (useful for elements that might be covered)
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
    }
}

class UITestBase: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.resetAppState()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    /// Launches the app and handles initial setup
    func launchApp() {
        app.launch()
        app.waitForIdle()
        app.dismissSystemAlerts()
    }
    
    /// Navigates to Add Alarm view
    func navigateToAddAlarm() {
        let addButton = app.buttons["add_alarm_button"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()
        
        // Wait for Add Alarm view to load
        let addAlarmNavBar = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmNavBar.waitForExistence(timeout: 3), "Should navigate to Add Alarm view")
    }
    
    /// Returns to main alarms view
    func returnToMainView() {
        let cancelButton = app.buttons["Cancel"]
        if cancelButton.exists {
            cancelButton.tap()
        }
        
        let alarmsNavBar = app.navigationBars["Alarms"]
        XCTAssertTrue(alarmsNavBar.waitForExistence(timeout: 3), "Should be in Alarms view")
    }
    
    /// Creates a test alarm with specified parameters
    func createTestAlarm(note: String = "Test Alarm", sound: String = "Default") {
        navigateToAddAlarm()
        
        // Fill in the note
        let noteField = app.textFields["note_field"]
        XCTAssertTrue(noteField.waitForExistence(timeout: 2), "Note field should exist")
        noteField.tap()
        noteField.typeText(note)
        
        // Select sound if not default
        if sound != "Default" {
            let soundPicker = app.buttons["sound_picker"]
            XCTAssertTrue(soundPicker.exists, "Sound picker should exist")
            soundPicker.tap()
            
            let soundOption = app.buttons[sound]
            if soundOption.exists {
                soundOption.tap()
            }
        }
        
        // Save the alarm
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()
        
        // Wait for return to main view
        let alarmsNavBar = app.navigationBars["Alarms"]
        XCTAssertTrue(alarmsNavBar.waitForExistence(timeout: 3), "Should return to Alarms view")
    }
    
    /// Deletes all alarms in the list
    func deleteAllAlarms() {
        let editButton = app.buttons["Edit"]
        if editButton.exists {
            editButton.tap()
            
            let alarmsList = app.tables.firstMatch
            if alarmsList.exists {
                let cells = alarmsList.cells
                while cells.count > 0 {
                    let firstCell = cells.firstMatch
                    firstCell.swipeLeft()
                    
                    let deleteButton = app.buttons["Delete"]
                    if deleteButton.waitForExistence(timeout: 2) {
                        deleteButton.tap()
                    }
                }
            }
            
            // Exit edit mode
            let doneButton = app.buttons["Done"]
            if doneButton.exists {
                doneButton.tap()
            }
        }
    }
    
    /// Asserts that an alarm with the given note exists in the list
    func assertAlarmExists(note: String) {
        let alarmNote = app.staticTexts[note]
        XCTAssertTrue(alarmNote.waitForExistence(timeout: 3), "Alarm with note '\(note)' should exist in the list")
    }
    
    /// Asserts that an alarm with the given note does not exist in the list
    func assertAlarmDoesNotExist(note: String) {
        let alarmNote = app.staticTexts[note]
        XCTAssertFalse(alarmNote.exists, "Alarm with note '\(note)' should not exist in the list")
    }
}