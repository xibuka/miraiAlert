//
//  Persistence.swift
//  MiraiAlert
//
//  Created by Wenhan Shi on 2025/07/09.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample alarms for preview
        let sampleAlarms = [
            (Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), "Morning run", "Radar"),
            (Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(), "Doctor appointment", "Beacon"),
            (Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), "Meeting", "Default"),
            (Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(), "Weekly review", "Radar")
        ]
        
        for (date, note, sound) in sampleAlarms {
            let alarm = AlarmEntity.createAlarm(context: viewContext, date: date, note: note, soundName: sound)
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MiraiAlert")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
