import SwiftUI

struct DashboardView: View {
    let dashboardState: DashboardState
    let permissionState: HealthPermissionState
    let isLoading: Bool
    let errorMessage: String?
    let onRefresh: () async -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScoreHeader(score: dashboardState.score)

                    if let errorMessage {
                        MessageBanner(icon: "exclamationmark.triangle", title: "Health data unavailable", message: errorMessage)
                    } else if dashboardState.score.status == .insufficientData {
                        MessageBanner(
                            icon: "calendar.badge.clock",
                            title: "More data needed",
                            message: dashboardState.score.summary
                        )
                    }

                    TodayMetricsView(summary: dashboardState.today)

                    ContributorsView(contributors: dashboardState.score.contributors)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await onRefresh() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                    .accessibilityLabel("Refresh Health data")
                }
            }
            .refreshable {
                await onRefresh()
            }
        }
    }
}

private struct ScoreHeader: View {
    let score: RecoveryScore

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(score.status.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(score.summary)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 16)

                ZStack {
                    Circle()
                        .stroke(.teal.opacity(0.16), lineWidth: 12)
                    Circle()
                        .trim(from: 0, to: CGFloat((score.value ?? 0)) / 100)
                        .stroke(.teal, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text(score.value.map(String.init) ?? "--")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                }
                .frame(width: 104, height: 104)
            }

            Text("Based on \(score.baselineDays) baseline days. This is a wellness signal, not a diagnosis or medical conclusion.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct TodayMetricsView: View {
    let summary: DailyHealthSummary?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today’s inputs")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricTile(title: "HRV", value: summary?.hrvMilliseconds.map { "\(Int($0.rounded())) ms" } ?? "--", icon: "waveform.path.ecg")
                MetricTile(title: "Resting HR", value: summary?.restingHeartRate.map { "\(Int($0.rounded())) bpm" } ?? "--", icon: "heart")
                MetricTile(title: "Sleep", value: summary?.sleepHours.map { String(format: "%.1f h", $0) } ?? "--", icon: "bed.double")
                MetricTile(title: "Active energy", value: summary?.activeEnergyKilocalories.map { "\(Int($0.rounded())) kcal" } ?? "--", icon: "flame")
            }
        }
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.teal)
            Text(value)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ContributorsView: View {
    let contributors: [RecoveryContributor]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Score contributors")
                .font(.headline)

            if contributors.isEmpty {
                Text("Contributors will appear after Nervio can compare today with your rolling baseline.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
            } else {
                ForEach(contributors) { contributor in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: icon(for: contributor.direction))
                            .foregroundStyle(color(for: contributor.direction))
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(contributor.title)
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                                Text(contributor.value)
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }

                            Text(contributor.detail)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private func icon(for direction: RecoveryContributor.Direction) -> String {
        switch direction {
        case .supportive: "arrow.up.circle.fill"
        case .neutral: "equal.circle.fill"
        case .load: "arrow.down.circle.fill"
        }
    }

    private func color(for direction: RecoveryContributor.Direction) -> Color {
        switch direction {
        case .supportive: .teal
        case .neutral: .secondary
        case .load: .orange
        }
    }
}

private struct MessageBanner: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    DashboardView(
        dashboardState: .mock,
        permissionState: .authorized,
        isLoading: false,
        errorMessage: nil,
        onRefresh: { }
    )
}
