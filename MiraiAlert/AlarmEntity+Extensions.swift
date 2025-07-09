import Foundation
import CoreData

extension AlarmEntity {
    static func createAlarm(context: NSManagedObjectContext, date: Date, note: String = "", soundName: String = "Default", isEnabled: Bool = true) -> AlarmEntity {
        let alarm = AlarmEntity(context: context)
        alarm.id = UUID()
        alarm.date = date
        alarm.note = note.isEmpty ? nil : note
        alarm.soundName = soundName
        alarm.isEnabled = isEnabled
        return alarm
    }
    
    func toAlarmModel() -> AlarmModel {
        return AlarmModel(
            date: self.date!,
            note: self.note ?? "",
            soundName: self.soundName!,
            isEnabled: self.isEnabled
        )
    }
}