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
                    setupNotifications()
                }
        }
    }
    
    private func setupNotifications() {
        Task {
            await notificationManager.updateAuthorizationStatus()
            if notificationManager.authorizationStatus == .notDetermined {
                await notificationManager.requestNotificationPermission()
            }
        }
        
        // Set up notification delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
}
