import SwiftUI
import UserNotifications

struct NotificationPermissionBanner: View {
    let authorizationStatus: UNAuthorizationStatus
    let onRequestPermission: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable Notifications")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(bannerMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button(action: onRequestPermission) {
                    Text(buttonText)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var bannerMessage: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Allow notifications to receive alarm alerts. This is optional but recommended for the best experience."
        case .denied:
            return "Notifications are disabled. You can enable them in Settings to receive alarm alerts."
        default:
            return "Enable notifications to receive alarm alerts."
        }
    }
    
    private var buttonText: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Allow Notifications"
        case .denied:
            return "Open Settings"
        default:
            return "Enable"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NotificationPermissionBanner(authorizationStatus: .notDetermined) { }
        NotificationPermissionBanner(authorizationStatus: .denied) { }
    }
    .background(Color.black)
}