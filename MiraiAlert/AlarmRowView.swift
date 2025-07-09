import SwiftUI

struct AlarmRowView: View {
    let alarm: AlarmModel
    @Binding var isEnabled: Bool
    @Environment(\.editMode) private var editMode
    
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
        formatter.dateFormat = "EEE, MMM d"
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom, spacing: 6) {
                    Text(timeFormatter.string(from: alarm.date))
                        .font(.system(size: 42, weight: .semibold, design: .default))
                        .foregroundColor(isEnabled ? .white : .gray)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Text(amPmFormatter.string(from: alarm.date))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isEnabled ? .white : .gray)
                        .padding(.bottom, 6)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .fixedSize(horizontal: true, vertical: false)
                
                Text(dateFormatter.string(from: alarm.date))
                    .font(.system(size: 17))
                    .foregroundColor(isEnabled ? .white : .gray)
                
                if !alarm.note.isEmpty {
                    Text(alarm.note)
                        .font(.system(size: 15))
                        .foregroundColor(isEnabled ? .secondary : .gray)
                }
            }
            
            Spacer()
            
            if editMode?.wrappedValue == .inactive {
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                    .scaleEffect(0.8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .opacity(editMode?.wrappedValue == .active ? 0.8 : 1.0)
    }
}

#Preview {
    VStack(spacing: 12) {
        AlarmRowView(
            alarm: AlarmModel(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                note: "Morning run",
                soundName: "Radar"
            ),
            isEnabled: .constant(true)
        )
        
        AlarmRowView(
            alarm: AlarmModel(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                note: "Doctor appointment",
                soundName: "Beacon",
                isEnabled: false
            ),
            isEnabled: .constant(false)
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}