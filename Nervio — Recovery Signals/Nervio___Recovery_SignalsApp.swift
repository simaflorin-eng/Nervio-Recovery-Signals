import SwiftUI
import UserNotifications

@main
struct NervioRecoverySignalsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if UserDefaults.standard.bool(forKey: "notificationsEnabled") {
                        await NervioNotificationManager.shared.requestPermission()
                    }
                }
        }
    }
}
