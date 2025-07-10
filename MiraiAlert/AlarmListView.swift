import SwiftUI
import CoreData

struct AlarmListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingAddAlarm = false
    
    @FetchRequest(
        entity: AlarmEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmEntity.date, ascending: true)],
        animation: .default)
    private var alarms: FetchedResults<AlarmEntity>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if alarms.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "alarm")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Alarms")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Add an alarm to get started")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(alarms, id: \.id) { alarm in
                            AlarmRowView(
                                alarm: alarm.toAlarmModel(),
                                isEnabled: Binding(
                                    get: { alarm.isEnabled },
                                    set: { newValue in
                                        alarm.isEnabled = newValue
                                        saveContext()
                                        
                                        // Update notification scheduling based on enabled state
                                        if newValue {
                                            // Schedule notification if enabling
                                            Task {
                                                await notificationManager.scheduleAlarmNotification(for: alarm)
                                            }
                                        } else {
                                            // Cancel notification if disabling
                                            if let alarmId = alarm.id {
                                                notificationManager.cancelAlarmNotification(for: alarmId)
                                            }
                                        }
                                    }
                                )
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                if editMode?.wrappedValue == .inactive {
                                    showingAddAlarm = true
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    deleteAlarm(alarm)
                                }) {
                                    Label("Delete Alarm", systemImage: "trash")
                                }
                                .foregroundColor(.red)
                                
                                Button(action: {
                                    alarm.isEnabled.toggle()
                                    saveContext()
                                    
                                    // Update notification scheduling
                                    if alarm.isEnabled {
                                        Task {
                                            await notificationManager.scheduleAlarmNotification(for: alarm)
                                        }
                                    } else {
                                        if let alarmId = alarm.id {
                                            notificationManager.cancelAlarmNotification(for: alarmId)
                                        }
                                    }
                                }) {
                                    Label(alarm.isEnabled ? "Disable Alarm" : "Enable Alarm", 
                                          systemImage: alarm.isEnabled ? "bell.slash" : "bell")
                                }
                            }
                        }
                        .onDelete(perform: deleteAlarms)
                        .onMove(perform: moveAlarms)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .environment(\.defaultMinListRowHeight, 80)
                    .accessibilityIdentifier("alarms_list")
                }
            }
            .navigationTitle("Alarms")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAlarm = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .accessibilityIdentifier("add_alarm_button")
                }
                
                if !alarms.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView()
        }
    }
    
    private func deleteAlarms(offsets: IndexSet) {
        withAnimation {
            let alarmsToDelete = offsets.map { alarms[$0] }
            
            // Cancel notifications for deleted alarms
            for alarm in alarmsToDelete {
                if let alarmId = alarm.id {
                    notificationManager.cancelAlarmNotification(for: alarmId)
                }
            }
            
            alarmsToDelete.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func deleteAlarm(_ alarm: AlarmEntity) {
        withAnimation {
            // Cancel notification for deleted alarm
            if let alarmId = alarm.id {
                notificationManager.cancelAlarmNotification(for: alarmId)
            }
            
            viewContext.delete(alarm)
            saveContext()
        }
    }
    
    private func moveAlarms(from source: IndexSet, to destination: Int) {
        // Note: Moving alarms would require reordering logic
        // For now, we'll keep the automatic date-based sorting
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    AlarmListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}