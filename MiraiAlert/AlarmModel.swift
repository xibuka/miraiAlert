import Foundation

struct AlarmModel: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var note: String
    var soundName: String
    var isEnabled: Bool
    
    init(date: Date, note: String = "", soundName: String = "Default", isEnabled: Bool = true) {
        self.date = date
        self.note = note
        self.soundName = soundName
        self.isEnabled = isEnabled
    }
}

extension AlarmModel {
    static let mockAlarms: [AlarmModel] = [
        AlarmModel(date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), note: "Morning run", soundName: "Radar"),
        AlarmModel(date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(), note: "Doctor appointment", soundName: "Beacon", isEnabled: false),
        AlarmModel(date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), note: "Meeting", soundName: "Default"),
        AlarmModel(date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(), note: "Weekly review", soundName: "Radar")
    ]
}