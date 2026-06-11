import Foundation

struct NervioWidgetMetric: Codable, Hashable {
    let title: String
    let value: String
    let symbolName: String
}

struct NervioWidgetSnapshot: Codable, Hashable {
    let recoveryValue: Int?
    let stressValue: Int?
    let status: String
    let summary: String
    let baselineDays: Int
    let hrv: NervioWidgetMetric
    let restingHeartRate: NervioWidgetMetric
    let sleep: NervioWidgetMetric
    let steps: NervioWidgetMetric
    let stepsValue: Int?
    let updatedAt: Date
    let languageCode: String?
    let recoveryLabel: String?
    let stressLabel: String?
    let stepsLabel: String?

    static let preview = NervioWidgetSnapshot(
        recoveryValue: 82,
        stressValue: 28,
        status: "Recovery signal",
        summary: "Steady recovery signal today.",
        baselineDays: 20,
        hrv: NervioWidgetMetric(title: "HRV", value: "54 ms", symbolName: "waveform.path.ecg"),
        restingHeartRate: NervioWidgetMetric(title: "Resting HR", value: "58 bpm", symbolName: "heart"),
        sleep: NervioWidgetMetric(title: "Sleep", value: "7.2 h", symbolName: "bed.double"),
        steps: NervioWidgetMetric(title: "Steps", value: "12,430", symbolName: "figure.walk"),
        stepsValue: 12430,
        updatedAt: .now,
        languageCode: "en",
        recoveryLabel: "Recovery",
        stressLabel: "Stress",
        stepsLabel: "Steps"
    )

    static let unavailable = NervioWidgetSnapshot(
        recoveryValue: nil,
        stressValue: nil,
        status: "More data needed",
        summary: "Open Nervio to refresh Apple Health data.",
        baselineDays: 0,
        hrv: NervioWidgetMetric(title: "HRV", value: "--", symbolName: "waveform.path.ecg"),
        restingHeartRate: NervioWidgetMetric(title: "Resting HR", value: "--", symbolName: "heart"),
        sleep: NervioWidgetMetric(title: "Sleep", value: "--", symbolName: "bed.double"),
        steps: NervioWidgetMetric(title: "Steps", value: "--", symbolName: "figure.walk"),
        stepsValue: nil,
        updatedAt: .now,
        languageCode: "en",
        recoveryLabel: "Recovery",
        stressLabel: "Stress",
        stepsLabel: "Steps"
    )
}

enum NervioWidgetSnapshotStore {
    static let appGroupIdentifier = "group.com.florinsima.Nervio-Recovery-Signals"
    static let storageKey = "nervio.widget.snapshot"

    static func load() -> NervioWidgetSnapshot {
        guard let data = defaults.data(forKey: storageKey),
              let snapshot = try? JSONDecoder().decode(NervioWidgetSnapshot.self, from: data) else {
            return .unavailable
        }

        return snapshot
    }

    static func save(_ snapshot: NervioWidgetSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }
}
