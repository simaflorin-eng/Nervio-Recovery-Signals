import Combine
import Foundation
import WatchConnectivity
import WidgetKit

struct WatchNervioMetric: Codable, Hashable {
    let title: String
    let value: String
    let symbolName: String
}

struct WatchNervioSnapshot: Codable, Hashable {
    let recoveryValue: Int?
    let stressValue: Int?
    let status: String
    let summary: String
    let baselineDays: Int
    let hrv: WatchNervioMetric
    let restingHeartRate: WatchNervioMetric
    let sleep: WatchNervioMetric
    let steps: WatchNervioMetric
    let stepsValue: Int?
    let updatedAt: Date
    let languageCode: String?
    let recoveryLabel: String?
    let stressLabel: String?
    let stepsLabel: String?

    static let preview = WatchNervioSnapshot(
        recoveryValue: 74,
        stressValue: 31,
        status: "Recovery signal",
        summary: "Steady recovery signal today.",
        baselineDays: 20,
        hrv: WatchNervioMetric(title: "HRV", value: "54 ms", symbolName: "waveform.path.ecg"),
        restingHeartRate: WatchNervioMetric(title: "Resting HR", value: "58 bpm", symbolName: "heart"),
        sleep: WatchNervioMetric(title: "Sleep", value: "7.2 h", symbolName: "bed.double"),
        steps: WatchNervioMetric(title: "Steps", value: "12,430", symbolName: "figure.walk"),
        stepsValue: 12430,
        updatedAt: .now,
        languageCode: "en",
        recoveryLabel: "Recovery",
        stressLabel: "Stress",
        stepsLabel: "Steps"
    )
}

enum WatchNervioSnapshotStore {
    static let appGroupIdentifier = "group.com.florinsima.Nervio-Recovery-Signals"
    static let storageKey = "nervio.widget.snapshot"

    static func load() -> WatchNervioSnapshot {
        guard let data = defaults.data(forKey: storageKey),
              let snapshot = try? JSONDecoder().decode(WatchNervioSnapshot.self, from: data) else {
            return .preview
        }

        return snapshot
    }

    static func save(_ snapshot: WatchNervioSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }
}

extension WatchNervioSnapshot {
    func updatingSteps(_ stepsValue: Int) -> WatchNervioSnapshot {
        WatchNervioSnapshot(
            recoveryValue: recoveryValue,
            stressValue: stressValue,
            status: status,
            summary: summary,
            baselineDays: baselineDays,
            hrv: hrv,
            restingHeartRate: restingHeartRate,
            sleep: sleep,
            steps: WatchNervioMetric(title: "Steps", value: Self.stepsFormatter.string(from: NSNumber(value: stepsValue)) ?? "\(stepsValue)", symbolName: "figure.walk"),
            stepsValue: stepsValue,
            updatedAt: .now,
            languageCode: languageCode,
            recoveryLabel: recoveryLabel,
            stressLabel: stressLabel,
            stepsLabel: stepsLabel
        )
    }

    private static let stepsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

@MainActor
final class WatchNervioSession: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var snapshot: WatchNervioSnapshot = WatchNervioSnapshotStore.load()

    private let healthKitManager = WatchHealthKitManager()

    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    override init() {
        super.init()
        activate()
    }

    func activate() {
        guard let session else { return }

        session.delegate = self
        if session.activationState == .notActivated {
            session.activate()
        }

        Task {
            await healthKitManager.startObservingStepUpdates { [weak self] in
                guard let self else { return }
                await self.refreshStepsFromWatch()
            }
            await refreshStepsFromWatch()
        }
    }

    func refreshStepsFromWatch() async {
        await healthKitManager.requestStepAuthorizationIfNeeded()
        guard let stepsValue = await healthKitManager.fetchTodayAppleWatchSteps() else {
            return
        }

        apply(snapshot.updatingSteps(stepsValue))
        WidgetCenter.shared.reloadAllTimelines()
    }

    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        guard let data = applicationContext["nervio.widget.snapshot"] as? Data else {
            return
        }

        Task { @MainActor in
            guard let snapshot = try? JSONDecoder().decode(WatchNervioSnapshot.self, from: data) else {
                return
            }

            self.apply(snapshot)
        }
    }

#if os(iOS)
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) { }

    nonisolated func sessionDidDeactivate(_ session: WCSession) { }
#endif

    private func apply(_ snapshot: WatchNervioSnapshot) {
        WatchNervioSnapshotStore.save(snapshot)
        self.snapshot = snapshot
        WidgetCenter.shared.reloadAllTimelines()
    }
}
