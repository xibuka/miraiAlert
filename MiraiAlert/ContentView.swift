//
//  ContentView.swift
//  MiraiAlert
//
//  Created by Wenhan Shi on 2025/07/09.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notificationDelegate = NotificationDelegate.shared
    
    var body: some View {
        AlarmListView()
            .fullScreenCover(isPresented: $notificationDelegate.showingForegroundAlarm) {
                if let alarmData = notificationDelegate.currentAlarmData {
                    ForegroundAlarmView(alarmData: alarmData) {
                        notificationDelegate.showingForegroundAlarm = false
                        notificationDelegate.currentAlarmData = nil
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
