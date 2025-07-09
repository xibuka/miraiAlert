import Foundation
import AVFoundation
import AudioToolbox

class AlarmSoundPlayer: ObservableObject {
    static let shared = AlarmSoundPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playAlarmSound(soundName: String) {
        stopAlarmSound()
        
        guard let soundURL = getSoundURL(for: soundName) else {
            print("Could not find sound file for: \(soundName)")
            playDefaultSound()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1  // Loop indefinitely
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            isPlaying = true
            print("Playing alarm sound: \(soundName)")
        } catch {
            print("Error playing sound: \(error)")
            playDefaultSound()
        }
    }
    
    func stopAlarmSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        print("Stopped alarm sound")
    }
    
    private func getSoundURL(for soundName: String) -> URL? {
        switch soundName {
        case "Radar":
            // Try to find bundled sound file first
            if let bundledURL = Bundle.main.url(forResource: "Radar", withExtension: "caf") {
                return bundledURL
            }
            // Fallback to system sound
            return Bundle.main.url(forResource: "radar_sound", withExtension: "mp3")
            
        case "Beacon":
            // Try to find bundled sound file first
            if let bundledURL = Bundle.main.url(forResource: "Beacon", withExtension: "caf") {
                return bundledURL
            }
            // Fallback to system sound
            return Bundle.main.url(forResource: "beacon_sound", withExtension: "mp3")
            
        default:
            // Default sound - use a bundled alarm sound
            return Bundle.main.url(forResource: "default_alarm", withExtension: "mp3")
        }
    }
    
    private func playDefaultSound() {
        // Create a simple programmatic beep sound as last resort
        AudioServicesPlaySystemSound(1304) // System sound ID for a beep
        
        // Create a timer to repeat the beep
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.isPlaying {
                AudioServicesPlaySystemSound(1304)
            } else {
                timer.invalidate()
            }
        }
        
        isPlaying = true
    }
    
    func createDefaultSoundFiles() {
        // This function would be used to create simple sound files programmatically
        // For now, we'll rely on system sounds and the fallback beep
        print("Using system sounds and fallback beep")
    }
}