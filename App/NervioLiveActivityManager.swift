import ActivityKit
import Foundation

// Must mirror NervioActivityAttributes in the widget extension exactly.
struct NervioActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let recoveryValue: Int?
        let stressValue: Int?
        let summary: String
        let updatedAt: Date
    }
}

@MainActor
final class NervioLiveActivityManager {
    static let shared = NervioLiveActivityManager()
    private var currentActivity: Activity<NervioActivityAttributes>?

    private init() {}

    var areActivitiesEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    func startOrUpdate(with snapshot: NervioWidgetSnapshot) {
        guard areActivitiesEnabled else { return }
        let state = NervioActivityAttributes.ContentState(
            recoveryValue: snapshot.recoveryValue,
            stressValue: snapshot.stressValue,
            summary: snapshot.summary,
            updatedAt: snapshot.updatedAt
        )
        if let activity = currentActivity {
            Task {
                let content = ActivityContent(
                    state: state,
                    staleDate: Calendar.current.date(byAdding: .hour, value: 4, to: .now)
                )
                try? await activity.update(content)
            }
        } else {
            startNew(state: state)
        }
    }

    func startNew(state: NervioActivityAttributes.ContentState? = nil) {
        guard areActivitiesEnabled else { return }
        endAll()
        let defaultState = state ?? NervioActivityAttributes.ContentState(
            recoveryValue: nil, stressValue: nil, summary: "", updatedAt: .now
        )
        let content = ActivityContent(
            state: defaultState,
            staleDate: Calendar.current.date(byAdding: .hour, value: 4, to: .now)
        )
        currentActivity = try? Activity<NervioActivityAttributes>.request(
            attributes: NervioActivityAttributes(),
            content: content,
            pushType: nil
        )
    }

    func endAll() {
        Task {
            for activity in Activity<NervioActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            currentActivity = nil
        }
    }
}
