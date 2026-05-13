import AppIntents
import SwiftUI
import WidgetKit

struct NervioWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> NervioWidgetEntry {
        NervioWidgetEntry(date: .now, configuration: .recovery, snapshot: .preview)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> NervioWidgetEntry {
        NervioWidgetEntry(
            date: .now,
            configuration: configuration,
            snapshot: context.isPreview ? .preview : NervioWidgetSnapshotStore.load()
        )
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<NervioWidgetEntry> {
        let entry = NervioWidgetEntry(date: .now, configuration: configuration, snapshot: NervioWidgetSnapshotStore.load())
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

struct NervioWidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let snapshot: NervioWidgetSnapshot

    fileprivate var signal: WidgetSignalPresentation {
        WidgetSignalPresentation(signal: configuration.signal, snapshot: snapshot)
    }
}

struct FixedNervioWidgetProvider: TimelineProvider {
    let signal: NervioWidgetSignal

    func placeholder(in context: Context) -> FixedNervioWidgetEntry {
        FixedNervioWidgetEntry(date: .now, signal: signal, snapshot: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (FixedNervioWidgetEntry) -> Void) {
        completion(FixedNervioWidgetEntry(date: .now, signal: signal, snapshot: context.isPreview ? .preview : NervioWidgetSnapshotStore.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FixedNervioWidgetEntry>) -> Void) {
        let entry = FixedNervioWidgetEntry(date: .now, signal: signal, snapshot: NervioWidgetSnapshotStore.load())
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }
}

struct FixedNervioWidgetEntry: TimelineEntry {
    let date: Date
    let signal: NervioWidgetSignal
    let snapshot: NervioWidgetSnapshot

    fileprivate var presentation: WidgetSignalPresentation {
        WidgetSignalPresentation(signal: signal, snapshot: snapshot)
    }
}

struct nervio_widgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: NervioWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallNervioWidget(signal: entry.signal)
        case .systemMedium:
            MediumNervioWidget(signal: entry.signal, snapshot: entry.snapshot)
        case .systemLarge:
            LargeNervioWidget(signal: entry.signal, snapshot: entry.snapshot)
        case .accessoryCircular:
            AccessoryCircularNervioWidget(signal: entry.signal)
        case .accessoryRectangular:
            AccessoryRectangularNervioWidget(signal: entry.signal)
        default:
            SmallNervioWidget(signal: entry.signal)
        }
    }
}

struct FixedNervioWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: FixedNervioWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallNervioWidget(signal: entry.presentation)
        case .systemMedium:
            MediumNervioWidget(signal: entry.presentation, snapshot: entry.snapshot)
        case .systemLarge:
            LargeNervioWidget(signal: entry.presentation, snapshot: entry.snapshot)
        case .accessoryCircular:
            AccessoryCircularNervioWidget(signal: entry.presentation)
        case .accessoryRectangular:
            AccessoryRectangularNervioWidget(signal: entry.presentation)
        default:
            SmallNervioWidget(signal: entry.presentation)
        }
    }
}

private struct SmallNervioWidget: View {
    let signal: WidgetSignalPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HeaderRow(signal: signal)

            Spacer(minLength: 0)

            ScoreRing(value: signal.value, tint: signal.tint, gradientColors: signal.gradientColors, size: 72, lineWidth: 8)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(signal.shortState)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.78))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
        }
        .nervioWidgetPadding()
    }
}

private struct MediumNervioWidget: View {
    let signal: WidgetSignalPresentation
    let snapshot: NervioWidgetSnapshot

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                HeaderRow(signal: signal)

                Spacer(minLength: 0)

                HStack(alignment: .center, spacing: 12) {
                    ScoreRing(value: signal.value, tint: signal.tint, gradientColors: signal.gradientColors, size: 72, lineWidth: 9)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(signal.title)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(signal.tint)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        Text(signal.value.map(String.init) ?? "--")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                        Text(signal.shortState)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.72))
                            .lineLimit(1)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                MetricRow(metric: snapshot.hrv, tint: signal.tint)
                MetricRow(metric: snapshot.restingHeartRate, tint: signal.tint)
                MetricRow(metric: snapshot.sleep, tint: signal.tint)

                HStack(spacing: 4) {
                    Image(systemName: signal.secondaryIconName)
                    Text(signal.secondaryLine)
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(signal.secondaryTint)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: 126, alignment: .leading)
        }
        .nervioWidgetPadding()
    }
}

private struct LargeNervioWidget: View {
    let signal: WidgetSignalPresentation
    let snapshot: NervioWidgetSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HeaderRow(signal: signal)

            HStack(alignment: .center, spacing: 20) {
                ScoreRing(value: signal.value, tint: signal.tint, gradientColors: signal.gradientColors, size: 118, lineWidth: 13)

                VStack(alignment: .leading, spacing: 8) {
                    Text(signal.title)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(signal.tint)
                        .textCase(.uppercase)
                    Text(signal.value.map(String.init) ?? "--")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                    Text(signal.shortState)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.76))
                    Text(signal.secondaryLine)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(signal.secondaryTint)
                }

                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: 12) {
                MetricPill(metric: snapshot.hrv, tint: signal.tint)
                MetricPill(metric: snapshot.restingHeartRate, tint: signal.tint)
                MetricPill(metric: snapshot.sleep, tint: signal.tint)
            }
        }
        .nervioWidgetPadding()
    }
}

private struct AccessoryCircularNervioWidget: View {
    let signal: WidgetSignalPresentation

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Gauge(value: Double(signal.value ?? 0), in: 0...100) {
                Text(signal.accessoryTitle)
            } currentValueLabel: {
                Text(signal.value.map(String.init) ?? "--")
                    .monospacedDigit()
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(signal.tint)
        }
    }
}

private struct AccessoryRectangularNervioWidget: View {
    let signal: WidgetSignalPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(signal.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
            Text(signal.value.map { "Score \($0)" } ?? "Needs data")
                .font(.headline)
                .foregroundStyle(.white)
                .monospacedDigit()
                .lineLimit(1)
            Text(signal.shortState)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.68))
                .lineLimit(1)
        }
    }
}

private struct HeaderRow: View {
    let signal: WidgetSignalPresentation

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: signal.primaryIconName)
                .foregroundStyle(signal.tint)
                .frame(width: 16)
            Text(signal.title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Spacer(minLength: 0)
        }
    }
}

private struct ScoreRing: View {
    let value: Int?
    let tint: Color
    let gradientColors: [Color]
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.18), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(value ?? 0) / 100)
                .stroke(
                    LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            Text(value.map(String.init) ?? "--")
                .font(.system(size: size * 0.28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
        }
        .frame(width: size, height: size)
    }
}

private struct MetricRow: View {
    let metric: NervioWidgetMetric
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: metric.symbolName)
                .font(.caption2)
                .foregroundStyle(tint)
                .frame(width: 14)
            VStack(alignment: .leading, spacing: 1) {
                Text(metric.value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(metric.title)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.62))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
        }
    }
}

private struct MetricPill: View {
    let metric: NervioWidgetMetric
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: metric.symbolName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 22)
            Text(metric.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.72))
            Spacer(minLength: 8)
            Text(metric.value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .monospacedDigit()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct WidgetSignalPresentation {
    let signal: NervioWidgetSignal
    let snapshot: NervioWidgetSnapshot

    var value: Int? {
        switch signal {
        case .recovery: snapshot.recoveryValue
        case .stress: snapshot.stressValue
        }
    }

    var title: String {
        switch signal {
        case .recovery: "Recovery"
        case .stress: "Stress"
        }
    }

    var accessoryTitle: String {
        switch signal {
        case .recovery: "Rec"
        case .stress: "Load"
        }
    }

    var primaryIconName: String {
        switch signal {
        case .recovery: "heart.circle.fill"
        case .stress: "flame.circle.fill"
        }
    }

    var tint: Color {
        gradientColors.first ?? .teal
    }

    var gradientColors: [Color] {
        switch signal {
        case .recovery:
            return semanticRecoveryColors(for: snapshot.recoveryValue)
        case .stress:
            return semanticStressColors(for: snapshot.stressValue)
        }
    }

    var secondaryTint: Color {
        switch signal {
        case .recovery: .orange
        case .stress: .teal
        }
    }

    var secondaryIconName: String {
        switch signal {
        case .recovery: "flame"
        case .stress: "waveform.path.ecg"
        }
    }

    var secondaryLine: String {
        switch signal {
        case .recovery:
            return "Load \(snapshot.stressValue.map(String.init) ?? "--")"
        case .stress:
            return "Rec \(snapshot.recoveryValue.map(String.init) ?? "--")"
        }
    }

    var shortState: String {
        guard let value else {
            return "Needs data"
        }

        switch signal {
        case .recovery:
            switch value {
            case 80...100: return "Strong"
            case 60..<80: return "Steady"
            case 40..<60: return "Loaded"
            default: return "High load"
            }
        case .stress:
            switch value {
            case 75...100: return "High"
            case 50..<75: return "Elevated"
            case 25..<50: return "Moderate"
            default: return "Low"
            }
        }
    }
}

private func semanticRecoveryColors(for value: Int?) -> [Color] {
    guard let value else { return [.teal, .mint] }

    switch value {
    case 80...100:
        return [.green, .mint]
    case 60..<80:
        return [.yellow, .green]
    case 40..<60:
        return [.orange, .yellow]
    default:
        return [.red, .orange]
    }
}

private func semanticStressColors(for value: Int?) -> [Color] {
    guard let value else { return [.orange, .yellow] }

    switch value {
    case 75...100:
        return [.red, .orange]
    case 50..<75:
        return [.orange, .yellow]
    case 25..<50:
        return [.yellow, .green]
    default:
        return [.green, .mint]
    }
}

private extension View {
    func nervioWidgetPadding() -> some View {
        padding(14)
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color(red: 0.02, green: 0.03, blue: 0.04),
                        Color(red: 0.04, green: 0.06, blue: 0.07),
                        Color(red: 0.00, green: 0.11, blue: 0.11)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .colorScheme(.dark)
    }
}

struct nervio_widget: Widget {
    let kind: String = "nervio_signal_widget_v2"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: NervioWidgetProvider()) { entry in
            nervio_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio")
        .description("Choose Recovery or Stress / Load for your latest Nervio signal.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular])
    }
}

struct NervioRecoveryWidget: Widget {
    let kind: String = "nervio_recovery_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FixedNervioWidgetProvider(signal: .recovery)) { entry in
            FixedNervioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Recovery")
        .description("Shows your latest Nervio recovery signal.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular])
    }
}

struct NervioStressWidget: Widget {
    let kind: String = "nervio_stress_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FixedNervioWidgetProvider(signal: .stress)) { entry in
            FixedNervioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nervio Stress")
        .description("Shows your latest Nervio stress and load signal.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var recovery: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.signal = .recovery
        return intent
    }

    fileprivate static var stress: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.signal = .stress
        return intent
    }
}

#Preview(as: .systemSmall) {
    nervio_widget()
} timeline: {
    NervioWidgetEntry(date: .now, configuration: .recovery, snapshot: .preview)
    NervioWidgetEntry(date: .now, configuration: .stress, snapshot: .preview)
}

#Preview(as: .systemMedium) {
    nervio_widget()
} timeline: {
    NervioWidgetEntry(date: .now, configuration: .recovery, snapshot: .preview)
    NervioWidgetEntry(date: .now, configuration: .stress, snapshot: .preview)
}

#Preview(as: .systemLarge) {
    nervio_widget()
} timeline: {
    NervioWidgetEntry(date: .now, configuration: .recovery, snapshot: .preview)
    NervioWidgetEntry(date: .now, configuration: .stress, snapshot: .preview)
}
