//
//  MiraiAlertApp.swift
//  MiraiAlert
//
//  Created by Wenhan Shi on 2025/07/09.
//

import SwiftUI
import UserNotifications

@main
struct MiraiAlertApp: App {
    let persistenceController = PersistenceController.shared
    let notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationManager)
                .onAppear {
                    setupNotificationDelegate()
                }
        }
    }
    
    private func setupNotificationDelegate() {
        // Only set up notification delegate, don't request permissions automatically
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        // Update authorization status without requesting permission
        Task {
            await notificationManager.updateAuthorizationStatus()
        }
    }
}
