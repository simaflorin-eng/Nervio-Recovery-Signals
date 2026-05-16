import SwiftUI
import WidgetKit

private enum WatchComplicationL10n {
    static let appGroupIdentifier = "group.com.florinsima.Nervio-Recovery-Signals"

    private static let table: [String: [String: String]] = [
        "fr": ["Recovery": "Récupération", "Stress": "Stress", "Steps": "Pas", "Needs data": "Données requises", "Score": "Score", "Load": "Charge", "Rec": "Réc", "From Watch": "Depuis Watch"],
        "de": ["Recovery": "Erholung", "Stress": "Stress", "Steps": "Schritte", "Needs data": "Daten benötigt", "Score": "Score", "Load": "Belastung", "Rec": "Erh", "From Watch": "Von der Watch"],
        "es": ["Recovery": "Recuperación", "Stress": "Estrés", "Steps": "Pasos", "Needs data": "Faltan datos", "Score": "Puntuación", "Load": "Carga", "Rec": "Rec", "From Watch": "Desde Watch"],
        "it": ["Recovery": "Recupero", "Stress": "Stress", "Steps": "Passi", "Needs data": "Dati necessari", "Score": "Punteggio", "Load": "Carico", "Rec": "Rec", "From Watch": "Da Watch"],
        "pt": ["Recovery": "Recuperação", "Stress": "Estresse", "Steps": "Passos", "Needs data": "Dados necessários", "Score": "Pontuação", "Load": "Carga", "Rec": "Rec", "From Watch": "Do Watch"],
        "ro": ["Recovery": "Recuperare", "Stress": "Stres", "Steps": "Pași", "Needs data": "Date necesare", "Score": "Scor", "Load": "Încărcare", "Rec": "Rec", "From Watch": "De pe Watch"]
    ]

    static func t(_ key: String, languageCode: String?) -> String {
        let appGroupCode = (UserDefaults(suiteName: appGroupIdentifier)?.string(forKey: "selectedLanguageCode") ?? "system").lowercased()
        let snapshotCode = (languageCode ?? "system").lowercased()

        let resolvedCode: String
        if appGroupCode != "system" && !appGroupCode.isEmpty {
            resolvedCode = appGroupCode
        } else if snapshotCode != "system" && !snapshotCode.isEmpty {
            resolvedCode = snapshotCode
        } else {
            resolvedCode = Locale.current.language.languageCode?.identifier.lowercased() ?? "en"
        }

        guard let value = table[resolvedCode]?[key] else { return key }
        return value
    }
}

struct NervioComplicationMetric: Codable, Hashable {
    let title: String
    let value: String
    let symbolName: String
}

struct NervioComplicationSnapshot: Codable, Hashable {
    let recoveryValue: Int?
    let stressValue: Int?
    let status: String
    let summary: String
    let baselineDays: Int
    let hrv: NervioComplicationMetric
    let restingHeartRate: NervioComplicationMetric
    let sleep: NervioComplicationMetric
    let steps: NervioComplicationMetric
    let stepsValue: Int?
    let updatedAt: Date
    let languageCode: String?
    let recoveryLabel: String?
    let stressLabel: String?
    let stepsLabel: String?

    static let preview = NervioComplicationSnapshot(
        recoveryValue: 74,
        stressValue: 31,
        status: "Recovery signal",
        summary: "Steady recovery signal today.",
        baselineDays: 20,
        hrv: NervioComplicationMetric(title: "HRV", value: "54 ms", symbolName: "waveform.path.ecg"),
        restingHeartRate: NervioComplicationMetric(title: "Resting HR", value: "58 bpm", symbolName: "heart"),
        sleep: NervioComplicationMetric(title: "Sleep", value: "7.2 h", symbolName: "bed.double"),
        steps: NervioComplicationMetric(title: "Steps", value: "12,430", symbolName: "figure.walk"),
        stepsValue: 12430,
        updatedAt: .now,
        languageCode: "en",
        recoveryLabel: "Recovery",
        stressLabel: "Stress",
        stepsLabel: "Steps"
    )

    static let unavailable = NervioComplicationSnapshot(
        recoveryValue: nil,
        stressValue: nil,
        status: "Needs data",
        summary: "Open Nervio to refresh Health data.",
        baselineDays: 0,
        hrv: NervioComplicationMetric(title: "HRV", value: "--", symbolName: "waveform.path.ecg"),
        restingHeartRate: NervioComplicationMetric(title: "Resting HR", value: "--", symbolName: "heart"),
        sleep: NervioComplicationMetric(title: "Sleep", value: "--", symbolName: "bed.double"),
        steps: NervioComplicationMetric(title: "Steps", value: "--", symbolName: "figure.walk"),
        stepsValue: nil,
        updatedAt: .now,
        languageCode: "en",
        recoveryLabel: "Recovery",
        stressLabel: "Stress",
        stepsLabel: "Steps"
    )
}

enum NervioComplicationSnapshotStore {
    static let appGroupIdentifier = "group.com.florinsima.Nervio-Recovery-Signals"
    static let storageKey = "nervio.widget.snapshot"

    static func load() -> NervioComplicationSnapshot {
        guard let data = defaults.data(forKey: storageKey),
              let snapshot = try? JSONDecoder().decode(NervioComplicationSnapshot.self, from: data) else {
            return .unavailable
        }

        return snapshot
    }

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }
}

struct NervioComplicationProvider: TimelineProvider {
    let signal: NervioComplicationSignal

    func placeholder(in context: Context) -> NervioComplicationEntry {
        NervioComplicationEntry(date: .now, signal: signal, snapshot: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (NervioComplicationEntry) -> Void) {
        completion(NervioComplicationEntry(date: .now, signal: signal, snapshot: context.isPreview ? .preview : NervioComplicationSnapshotStore.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NervioComplicationEntry>) -> Void) {
        let entry = NervioComplicationEntry(date: .now, signal: signal, snapshot: NervioComplicationSnapshotStore.load())
        // Ask WidgetKit for a fresh timeline more often so steps refresh sooner.
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: .now) ?? .now.addingTimeInterval(300)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }
}

struct NervioComplicationEntry: TimelineEntry {
    let date: Date
    let signal: NervioComplicationSignal
    let snapshot: NervioComplicationSnapshot

    var presentation: NervioComplicationPresentation {
        NervioComplicationPresentation(signal: signal, snapshot: snapshot)
    }
}

enum NervioComplicationSignal {
    case recovery
    case stress
    case steps
}

struct NervioComplicationEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: NervioComplicationEntry

    var body: some View {
        let presentation = entry.presentation

        switch family {
        case .accessoryCircular:
            ZStack {
                Circle()
                    .stroke(presentation.tint.opacity(0.25), lineWidth: 3)
                VStack(spacing: 1) {
                    Image(systemName: presentation.symbolName)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(presentation.tint)
                    Text(presentation.valueText)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Label(presentation.title, systemImage: presentation.symbolName)
                    .font(.caption2)
                    .lineLimit(1)
                Text(presentation.primaryLine)
                    .font(.headline)
                    .monospacedDigit()
                    .lineLimit(1)
                Text(presentation.secondaryLine)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        case .accessoryInline:
            Text(presentation.inlineText)
        default:
            Text(presentation.inlineText)
        }
    }
}

struct NervioComplicationPresentation {
    let signal: NervioComplicationSignal
    let snapshot: NervioComplicationSnapshot

    var title: String {
        switch signal {
        case .recovery: snapshot.recoveryLabel ?? WatchComplicationL10n.t("Recovery", languageCode: snapshot.languageCode)
        case .stress: snapshot.stressLabel ?? WatchComplicationL10n.t("Stress", languageCode: snapshot.languageCode)
        case .steps: snapshot.stepsLabel ?? WatchComplicationL10n.t("Steps", languageCode: snapshot.languageCode)
        }
    }

    var shortTitle: String {
        switch signal {
        case .recovery: WatchComplicationL10n.t("Rec", languageCode: snapshot.languageCode)
        case .stress: WatchComplicationL10n.t("Load", languageCode: snapshot.languageCode)
        case .steps: WatchComplicationL10n.t("Steps", languageCode: snapshot.languageCode)
        }
    }

    var symbolName: String {
        switch signal {
        case .recovery: "heart.circle.fill"
        case .stress: "flame.circle.fill"
        case .steps: "figure.walk.circle.fill"
        }
    }

    var value: Int? {
        switch signal {
        case .recovery: snapshot.recoveryValue
        case .stress: snapshot.stressValue
        case .steps: snapshot.stepsValue
        }
    }

    var maximumValue: Double {
        signal == .steps ? 12000 : 100
    }

    var valueText: String {
        guard let value else { return "--" }

        if signal == .steps {
            return compactStepsText(value)
        }

        return "\(value)"
    }

    var primaryLine: String {
        switch signal {
        case .recovery, .stress:
            return value.map { "\(WatchComplicationL10n.t("Score", languageCode: snapshot.languageCode)) \($0)" } ?? WatchComplicationL10n.t("Needs data", languageCode: snapshot.languageCode)
        case .steps:
            return value.map { "\(stepsFormatter.string(from: NSNumber(value: $0)) ?? "\($0)") \(WatchComplicationL10n.t("Steps", languageCode: snapshot.languageCode))" } ?? WatchComplicationL10n.t("Needs data", languageCode: snapshot.languageCode)
        }
    }

    var secondaryLine: String {
        switch signal {
        case .recovery:
            return "\(WatchComplicationL10n.t("Load", languageCode: snapshot.languageCode)) \(snapshot.stressValue.map(String.init) ?? "--")"
        case .stress:
            return "\(WatchComplicationL10n.t("Rec", languageCode: snapshot.languageCode)) \(snapshot.recoveryValue.map(String.init) ?? "--")"
        case .steps:
            return WatchComplicationL10n.t("From Watch", languageCode: snapshot.languageCode)
        }
    }

    var inlineText: String {
        "Nervio \(shortTitle) \(valueText)"
    }

    var tint: Color {
        switch signal {
        case .recovery:
            return recoveryTint(for: snapshot.recoveryValue)
        case .stress:
            return stressTint(for: snapshot.stressValue)
        case .steps:
            return .cyan
        }
    }
}

private let stepsFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

private func compactStepsText(_ value: Int) -> String {
    stepsFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

private func recoveryTint(for value: Int?) -> Color {
    guard let value else { return .teal }

    switch value {
    case 80...100: return .green
    case 60..<80: return .yellow
    case 40..<60: return .orange
    default: return .red
    }
}

private func stressTint(for value: Int?) -> Color {
    guard let value else { return .orange }

    switch value {
    case 75...100: return .red
    case 50..<75: return .orange
    case 25..<50: return .yellow
    default: return .green
    }
}

struct NervioRecoveryComplication: Widget {
    let kind = "nervio_watch_recovery_complication_v2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .recovery)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Recovery")
        .description("Shows your latest recovery signal.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct NervioStressComplication: Widget {
    let kind = "nervio_watch_stress_complication_v2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .stress)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Stress")
        .description("Shows your latest stress and load signal.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct NervioStepsComplication: Widget {
    let kind = "nervio_watch_steps_complication_v2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .steps)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Steps")
        .description("Shows today's steps.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// Legacy kinds kept to update already-installed complications created before v2 kinds.
struct NervioRecoveryComplicationLegacy: Widget {
    let kind = "nervio_watch_recovery_complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .recovery)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Recovery")
        .description("Shows your latest recovery signal.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct NervioStressComplicationLegacy: Widget {
    let kind = "nervio_watch_stress_complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .stress)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Stress")
        .description("Shows your latest stress and load signal.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct NervioStepsComplicationLegacy: Widget {
    let kind = "nervio_watch_steps_complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioComplicationProvider(signal: .steps)) { entry in
            NervioComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Steps")
        .description("Shows today's steps.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryCircular) {
    NervioRecoveryComplication()
} timeline: {
    NervioComplicationEntry(date: .now, signal: .recovery, snapshot: .preview)
}

#Preview(as: .accessoryRectangular) {
    NervioStepsComplication()
} timeline: {
    NervioComplicationEntry(date: .now, signal: .steps, snapshot: .preview)
}
