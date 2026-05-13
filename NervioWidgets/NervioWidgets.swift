import SwiftUI
import WidgetKit

struct NervioWidgetEntry: TimelineEntry {
    let date: Date
    let recoveryScore: Int
    let stressScore: Int
    let hrv: Int
    let restingHeartRate: Int
    let sleepHours: Double
    let summary: String
}

struct NervioWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> NervioWidgetEntry {
        NervioWidgetEntry.sample
    }

    func getSnapshot(in context: Context, completion: @escaping (NervioWidgetEntry) -> Void) {
        completion(.sample)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NervioWidgetEntry>) -> Void) {
        let entry = NervioWidgetEntry.sample
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }
}

extension NervioWidgetEntry {
    static let sample = NervioWidgetEntry(
        date: Date(),
        recoveryScore: 82,
        stressScore: 28,
        hrv: 56,
        restingHeartRate: 58,
        sleepHours: 7.4,
        summary: "Strong recovery signal"
    )
}

struct NervioRecoveryWidget: Widget {
    let kind = "NervioRecoveryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioWidgetProvider()) { entry in
            NervioRecoveryWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    NervioWidgetBackground()
                }
        }
        .configurationDisplayName("Nervio Recovery")
        .description("Recovery and physiological load at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct NervioMetricsWidget: Widget {
    let kind = "NervioMetricsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioWidgetProvider()) { entry in
            NervioMetricsWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    NervioWidgetBackground()
                }
        }
        .configurationDisplayName("Nervio Signals")
        .description("HRV, resting heart rate, and sleep signals.")
        .supportedFamilies([.systemMedium])
    }
}

private struct NervioRecoveryWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: NervioWidgetEntry

    var body: some View {
        if family == .systemSmall {
            VStack(alignment: .leading, spacing: 10) {
                WidgetHeader(title: "Nervio", icon: "waveform.path.ecg")
                Spacer(minLength: 0)
                ScoreRing(value: entry.recoveryScore, tint: .teal, size: 82, lineWidth: 9)
                    .frame(maxWidth: .infinity)
                Text(entry.summary)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding(2)
        } else {
            HStack(spacing: 16) {
                ScoreRing(value: entry.recoveryScore, tint: .teal, size: 104, lineWidth: 11)
                VStack(alignment: .leading, spacing: 10) {
                    WidgetHeader(title: "Recovery", icon: "waveform.path.ecg")
                    Text(entry.summary)
                        .font(.headline.weight(.bold))
                        .lineLimit(2)
                    LoadPill(value: entry.stressScore)
                    Spacer(minLength: 0)
                }
            }
            .padding(2)
        }
    }
}

private struct NervioMetricsWidgetView: View {
    let entry: NervioWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                WidgetHeader(title: "Signals", icon: "heart.text.square")
                Spacer()
                LoadPill(value: entry.stressScore)
            }

            HStack(spacing: 10) {
                MetricCapsule(title: "HRV", value: "\(entry.hrv) ms", tint: .teal, icon: "waveform.path.ecg")
                MetricCapsule(title: "RHR", value: "\(entry.restingHeartRate) bpm", tint: .pink, icon: "heart")
                MetricCapsule(title: "Sleep", value: String(format: "%.1f h", entry.sleepHours), tint: .indigo, icon: "bed.double")
            }

            Text(entry.summary)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(2)
    }
}

private struct WidgetHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(.teal.gradient, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
        }
    }
}

private struct ScoreRing: View {
    let value: Int
    let tint: Color
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.16), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(value) / 100)
                .stroke(
                    LinearGradient(colors: [tint, .mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("\(value)")
                    .font(.system(size: size * 0.34, weight: .bold, design: .rounded))
                Text("REC")
                    .font(.system(size: size * 0.10, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
    }
}

private struct LoadPill: View {
    let value: Int

    var body: some View {
        Label("\(value) load", systemImage: "bolt.heart")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.orange)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(.orange.opacity(0.12), in: Capsule())
    }
}

private struct MetricCapsule: View {
    let title: String
    let value: String
    let tint: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(tint)
            Text(value)
                .font(.caption.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(9)
        .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(tint.opacity(0.20), lineWidth: 1)
        }
    }
}

private struct NervioWidgetBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.90, green: 0.99, blue: 0.98),
                Color(red: 0.98, green: 0.96, blue: 0.93),
                Color(red: 0.93, green: 0.95, blue: 1.00)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            LinearGradient(
                colors: [.teal.opacity(0.18), .clear, .pink.opacity(0.10)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

@main
struct NervioWidgetsBundle: WidgetBundle {
    var body: some Widget {
        NervioRecoveryWidget()
        NervioMetricsWidget()
    }
}

#Preview(as: .systemSmall) {
    NervioRecoveryWidget()
} timeline: {
    NervioWidgetEntry.sample
}

#Preview(as: .systemMedium) {
    NervioMetricsWidget()
} timeline: {
    NervioWidgetEntry.sample
}
