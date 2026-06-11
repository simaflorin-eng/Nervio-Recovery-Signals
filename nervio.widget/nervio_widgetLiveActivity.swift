import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Widget

struct nervio_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NervioActivityAttributes.self) { context in
            NervioLockScreenView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    NervioExpandedLeading(state: context.state)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    NervioExpandedTrailing(state: context.state)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    NervioExpandedBottom(state: context.state)
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Circle()
                        .fill(liveActivityRecoveryColor(for: context.state.recoveryValue))
                        .frame(width: 7, height: 7)
                    Text(context.state.recoveryValue.map(String.init) ?? "--")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                }
                .padding(.leading, 4)
            } compactTrailing: {
                Text("REC")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(liveActivityRecoveryColor(for: context.state.recoveryValue))
                    .padding(.trailing, 4)
            } minimal: {
                Text(context.state.recoveryValue.map(String.init) ?? "--")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(liveActivityRecoveryColor(for: context.state.recoveryValue))
            }
            .widgetURL(URL(string: "nervio://"))
            .keylineTint(liveActivityRecoveryColor(for: context.state.recoveryValue))
        }
    }
}

// MARK: - Lock Screen Banner

private struct NervioLockScreenView: View {
    let state: NervioActivityAttributes.ContentState

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 3)
                Circle()
                    .trim(from: 0, to: CGFloat(Double(state.recoveryValue ?? 0) / 100.0))
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(state.recoveryValue.map(String.init) ?? "--")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 3) {
                Text("RECOVERY")
                    .font(.caption2.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(scoreColor)
                Text(state.summary)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 3) {
                Text("STRESS")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .tracking(0.8)
                    .foregroundStyle(stressColor)
                Text(state.stressValue.map(String.init) ?? "--")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }
        }
        .padding(14)
        .activityBackgroundTint(Color(red: 0.04, green: 0.06, blue: 0.11))
        .activitySystemActionForegroundColor(.white)
    }

    private var scoreColor: Color { liveActivityRecoveryColor(for: state.recoveryValue) }
    private var stressColor: Color { liveActivityStressColor(for: state.stressValue) }
}

// MARK: - Dynamic Island Expanded Regions

private struct NervioExpandedLeading: View {
    let state: NervioActivityAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("RECOVERY")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(liveActivityRecoveryColor(for: state.recoveryValue))
            Text(state.recoveryValue.map(String.init) ?? "--")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .padding(.leading, 8)
    }
}

private struct NervioExpandedTrailing: View {
    let state: NervioActivityAttributes.ContentState

    var body: some View {
        VStack(alignment: .trailing, spacing: 1) {
            Text("STRESS")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(liveActivityStressColor(for: state.stressValue))
            Text(state.stressValue.map(String.init) ?? "--")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .padding(.trailing, 8)
    }
}

private struct NervioExpandedBottom: View {
    let state: NervioActivityAttributes.ContentState

    var body: some View {
        HStack {
            Text(state.summary)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
                .lineLimit(2)
            Spacer()
            Text(state.updatedAt, style: .time)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.38))
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
    }
}

// MARK: - Color Helpers

private func liveActivityRecoveryColor(for value: Int?) -> Color {
    guard let value else { return .teal }
    switch value {
    case 70...100: return .green
    case 52..<70:  return .yellow
    case 35..<52:  return .orange
    default:       return .red
    }
}

private func liveActivityStressColor(for value: Int?) -> Color {
    guard let value else { return .orange }
    switch value {
    case 75...100: return .red
    case 50..<75:  return .orange
    case 25..<50:  return .yellow
    default:       return .green
    }
}
