import Foundation
import UserNotifications
import CoreData

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private init() {}
    
    func requestNotificationPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            
            await MainActor.run {
                self.isAuthorized = granted
            }
            
            await updateAuthorizationStatus()
        } catch {
            print("Error requesting notification permission: \(error)")
        }
    }
    
    func updateAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            self.authorizationStatus = settings.authorizationStatus
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }
    
    func scheduleAlarmNotification(for alarm: AlarmEntity) async {
        guard isAuthorized else {
            print("Notification permission not granted - alarm saved but no notification will be scheduled")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.note ?? "Time to wake up!"
        content.sound = getNotificationSound(for: alarm.soundName ?? "Default")
        content.categoryIdentifier = "ALARM_CATEGORY"
        content.userInfo = ["soundName": alarm.soundName ?? "Default"]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: alarm.date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: alarm.id!.uuidString,
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("Alarm notification scheduled for: \(alarm.date!)")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }
    
    func cancelAlarmNotification(for alarmId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmId.uuidString])
        print("Cancelled notification for alarm: \(alarmId)")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending notifications cancelled")
    }
    
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
    
    private func getNotificationSound(for soundName: String) -> UNNotificationSound {
        switch soundName {
        case "Radar":
            return UNNotificationSound(named: UNNotificationSoundName("Radar.caf"))
        case "Beacon":
            return UNNotificationSound(named: UNNotificationSoundName("Beacon.caf"))
        default:
            return UNNotificationSound.default
        }
    }
}