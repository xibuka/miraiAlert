import Foundation
import UserNotifications
import SwiftUI

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    static let shared = NotificationDelegate()
    
    @Published var currentAlarmData: AlarmNotificationData?
    @Published var showingForegroundAlarm = false
    
    override init() {
        super.init()
    }
    
    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        let alarmId = notification.request.identifier
        let title = notification.request.content.title
        let body = notification.request.content.body
        let soundName = userInfo["soundName"] as? String ?? "Default"
        
        // Store alarm data for foreground modal
        DispatchQueue.main.async {
            self.currentAlarmData = AlarmNotificationData(
                id: alarmId,
                title: title,
                body: body,
                soundName: soundName
            )
            self.showingForegroundAlarm = true
        }
        
        // Start playing the alarm sound
        AlarmSoundPlayer.shared.playAlarmSound(soundName: soundName)
        
        // Don't show system notification banner in foreground
        completionHandler([])
    }
    
    // Handle notification tap when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let alarmId = response.notification.request.identifier
        
        print("User tapped notification for alarm: \(alarmId)")
        
        // Handle the notification tap (e.g., open specific alarm details)
        completionHandler()
    }
    
    private func extractSoundName(from sound: UNNotificationSound?) -> String {
        // Extract sound name from UNNotificationSound
        // This is a simplified approach - in real app you might need more sophisticated parsing
        if let sound = sound {
            if sound == UNNotificationSound.default {
                return "Default"
            } else {
                // For custom sounds, we'll need to track this differently
                // For now, default to "Default"
                return "Default"
            }
        }
        return "Default"
    }
}

struct AlarmNotificationData {
    let id: String
    let title: String
    let body: String
    let soundName: String
}