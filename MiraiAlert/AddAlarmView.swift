import SwiftUI
import CoreData

struct AddAlarmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var note = ""
    @State private var selectedSound = "Default"
    @State private var showingDateError = false
    @State private var showingPermissionAlert = false
    
    private let soundOptions = ["Default", "Radar", "Beacon", "Chime", "Bell"]
    
    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute

        return calendar.date(from: combined) ?? date
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }
    
    private var amPmFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Time preview section
                        VStack(spacing: 8) {
                            HStack(alignment: .bottom, spacing: 8) {
                                Text(timeFormatter.string(from: selectedTime))
                                    .font(.system(size: 64, weight: .semibold, design: .default))
                                    .foregroundColor(.white)
                                
                                Text(amPmFormatter.string(from: selectedTime))
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 12)
                            }
                            
                            Text(dateFormatter.string(from: selectedDate))
                                .font(.system(size: 18))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        // Form sections
                        VStack(spacing: 20) {
                            // Date section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .accessibilityIdentifier("date_picker")
                            }
                            
                            // Time section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .accessibilityIdentifier("time_picker")
                            }
                            
                            // Note section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                TextField("Alarm note", text: $note)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .accessibilityIdentifier("note_field")
                            }
                            
                            // Sound section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sound")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                VStack(spacing: 0) {
                                    ForEach(Array(soundOptions.enumerated()), id: \.offset) { index, sound in
                                        Button(action: {
                                            selectedSound = sound
                                            // Add haptic feedback
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                            impactFeedback.impactOccurred()
                                        }) {
                                            HStack {
                                                Text(sound)
                                                    .font(.system(size: 16, weight: .regular))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                if selectedSound == sound {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                selectedSound == sound 
                                                    ? Color.orange.opacity(0.1) 
                                                    : Color.clear
                                            )
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(.plain)
                                        
                                        if index < soundOptions.count - 1 {
                                            Divider()
                                                .background(Color.gray.opacity(0.3))
                                        }
                                    }
                                }
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .accessibilityIdentifier("sound_picker")
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Add Alarm")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAlarm()
                    }
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Invalid Date", isPresented: $showingDateError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a date and time in the future.")
        }
        .alert("Notification Permission Required", isPresented: $showingPermissionAlert) {
            Button("Go to Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications in Settings to receive alarm alerts.")
        }
    }
    
    private func saveAlarm() {
        let finalDateTime = combine(date: selectedDate, time: selectedTime)
        
        // Validate that the date is in the future
        if finalDateTime <= Date() {
            showingDateError = true
            return
        }
        
        // Check notification permission
        if !notificationManager.isAuthorized {
            showingPermissionAlert = true
            return
        }
        
        // Create new alarm entity
        let newAlarm = AlarmEntity.createAlarm(
            context: viewContext,
            date: finalDateTime,
            note: note,
            soundName: selectedSound
        )
        
        // Save to CoreData
        do {
            try viewContext.save()
            
            // Schedule notification
            Task {
                await notificationManager.scheduleAlarmNotification(for: newAlarm)
            }
            
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    AddAlarmView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}