import SwiftUI

struct ForegroundAlarmView: View {
    let alarmData: AlarmNotificationData
    @ObservedObject var soundPlayer = AlarmSoundPlayer.shared
    @State private var currentTime = Date()
    @State private var timer: Timer?
    
    var dismissAction: () -> Void
    
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
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Current time display
                VStack(spacing: 8) {
                    HStack(alignment: .bottom, spacing: 8) {
                        Text(timeFormatter.string(from: currentTime))
                            .font(.system(size: 72, weight: .thin, design: .default))
                            .foregroundColor(.white)
                        
                        Text(amPmFormatter.string(from: currentTime))
                            .font(.system(size: 36, weight: .light))
                            .foregroundColor(.white)
                            .padding(.bottom, 16)
                    }
                }
                
                // Alarm info
                VStack(spacing: 16) {
                    Text("Alarm")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    if !alarmData.body.isEmpty {
                        Text(alarmData.body)
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    // Sound indicator
                    HStack(spacing: 8) {
                        Image(systemName: soundPlayer.isPlaying ? "speaker.wave.3" : "speaker.slash")
                            .foregroundColor(.orange)
                        
                        Text(alarmData.soundName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Stop button
                Button(action: stopAlarm) {
                    HStack(spacing: 12) {
                        Image(systemName: "stop.circle.fill")
                            .font(.title2)
                        
                        Text("Stop")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 56)
                    .background(Color.orange)
                    .cornerRadius(28)
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime = Date()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func stopAlarm() {
        soundPlayer.stopAlarmSound()
        stopTimer()
        dismissAction()
    }
}

#Preview {
    ForegroundAlarmView(
        alarmData: AlarmNotificationData(
            id: "test-id",
            title: "Alarm",
            body: "Meeting with boss",
            soundName: "Radar"
        ),
        dismissAction: {}
    )
}