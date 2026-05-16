import SwiftUI

struct NervioWatchDashboardView: View {
    @StateObject private var session = WatchNervioSession()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 12) {
                        WatchSignalRing(
                            title: "Recovery",
                            value: session.snapshot.recoveryValue,
                            systemImage: "heart.circle.fill",
                            colors: recoveryColors(for: session.snapshot.recoveryValue),
                            size: ringSize(for: geometry.size.width)
                        )

                        WatchSignalRing(
                            title: "Stress",
                            value: session.snapshot.stressValue,
                            systemImage: "flame.circle.fill",
                            colors: stressColors(for: session.snapshot.stressValue),
                            size: ringSize(for: geometry.size.width)
                        )

                        WatchSignalRing(
                            title: "Steps",
                            value: stepsProgressValue,
                            centerText: session.snapshot.steps.value,
                            systemImage: "figure.walk.circle.fill",
                            colors: [.green, .mint],
                            size: ringSize(for: geometry.size.width)
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                }
            }
            .containerBackground(.black, for: .navigation)
            .task(id: context.date) {
                await session.refreshStepsFromWatch()
            }
        }
        .task {
            await session.refreshStepsFromWatch()
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .active else { return }
            Task {
                await session.refreshStepsFromWatch()
            }
        }
    }

    private var stepsProgressValue: Int? {
        guard let steps = session.snapshot.stepsValue else { return nil }
        return min(100, Int((Double(steps) / 10000 * 100).rounded()))
    }

    private func ringSize(for width: CGFloat) -> CGFloat {
        min(92, max(76, width - 42))
    }
}

private struct WatchSignalRing: View {
    let title: String
    let value: Int?
    var centerText: String?
    let systemImage: String
    let colors: [Color]
    let size: CGFloat

    private var lineWidth: CGFloat {
        max(7, size * 0.085)
    }

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .stroke((colors.first ?? .green).opacity(0.18), lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: CGFloat(value ?? 0) / 100)
                    .stroke(
                        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Image(systemName: systemImage)
                        .font(.system(size: max(10, size * 0.13), weight: .semibold))
                        .foregroundStyle(colors.first ?? .green)
                    Text(centerText ?? value.map(String.init) ?? "--")
                        .font(.system(size: centerText == nil ? size * 0.24 : size * 0.17, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)
                        .monospacedDigit()
                }
                .padding(.horizontal, 10)
            }
            .frame(width: size, height: size)
            .padding(lineWidth / 2)

            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

private func recoveryColors(for value: Int?) -> [Color] {
    guard let value else { return [.teal, .mint] }

    switch value {
    case 80...100: return [.green, .mint]
    case 60..<80: return [.yellow, .green]
    case 40..<60: return [.orange, .yellow]
    default: return [.red, .orange]
    }
}

private func stressColors(for value: Int?) -> [Color] {
    guard let value else { return [.orange, .yellow] }

    switch value {
    case 75...100: return [.red, .orange]
    case 50..<75: return [.orange, .yellow]
    case 25..<50: return [.yellow, .green]
    default: return [.green, .mint]
    }
}

#Preview {
    NervioWatchDashboardView()
}
