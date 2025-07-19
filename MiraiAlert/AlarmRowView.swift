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
            VStack(alignment: .leading, spacing: 4) {
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
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isEnabled ? .white : .gray)
                
                if !alarm.note.isEmpty {
                    Text(alarm.note)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isEnabled ? .gray : .gray.opacity(0.7))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 2)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                .scaleEffect(0.8)
                .opacity(editMode?.wrappedValue == .inactive ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.2), value: editMode?.wrappedValue)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
        .opacity(editMode?.wrappedValue == .active ? 0.8 : 1.0)
    }
}

#Preview {
    VStack(spacing: 12) {
        AlarmRowView(
            alarm: AlarmModel(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                note: "Morning run - Don't forget your running shoes!",
                soundName: "Radar"
            ),
            isEnabled: .constant(true)
        )
        
        AlarmRowView(
            alarm: AlarmModel(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                note: "Doctor appointment at City Hospital",
                soundName: "Beacon",
                isEnabled: false
            ),
            isEnabled: .constant(false)
        )
        
        AlarmRowView(
            alarm: AlarmModel(
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                note: "",
                soundName: "Default"
            ),
            isEnabled: .constant(true)
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}