import Charts
import SwiftUI

struct TrendsView: View {
    let dashboardState: DashboardState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TrendChart(
                        title: "HRV",
                        unit: "ms",
                        color: .teal,
                        points: dashboardState.history.compactMap { summary in
                            summary.hrvMilliseconds.map { TrendPoint(date: summary.date, value: $0) }
                        }
                    )

                    TrendChart(
                        title: "Resting heart rate",
                        unit: "bpm",
                        color: .pink,
                        points: dashboardState.history.compactMap { summary in
                            summary.restingHeartRate.map { TrendPoint(date: summary.date, value: $0) }
                        }
                    )

                    TrendChart(
                        title: "Sleep",
                        unit: "hours",
                        color: .indigo,
                        points: dashboardState.history.compactMap { summary in
                            summary.sleepHours.map { TrendPoint(date: summary.date, value: $0) }
                        }
                    )

                    Text("Trends compare available Apple Health samples over time. Missing points usually mean no readable data was available for that day.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Trends")
        }
    }
}

private struct TrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

private struct TrendChart: View {
    let title: String
    let unit: String
    let color: Color
    let points: [TrendPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(latestValue)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            if points.isEmpty {
                Text("No readable data yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                Chart(points) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value(title, point.value)
                    )
                    .foregroundStyle(color)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value(title, point.value)
                    )
                    .foregroundStyle(color.opacity(0.12))
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 180)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }

    private var latestValue: String {
        guard let value = points.last?.value else { return "--" }
        return "\(String(format: "%.1f", value)) \(unit)"
    }
}

#Preview {
    TrendsView(dashboardState: .mock)
}
