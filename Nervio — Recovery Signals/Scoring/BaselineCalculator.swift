import Foundation

struct BaselineCalculator {
    private let minimumDays: Int
    private let maximumDays: Int

    init(minimumDays: Int = 7, maximumDays: Int = 28) {
        self.minimumDays = minimumDays
        self.maximumDays = maximumDays
    }

    func baseline(from summaries: [DailyHealthSummary], before date: Date = Date()) -> (baseline: HealthBaseline, days: Int) {
        let calendar = Calendar.current
        let startOfTargetDay = calendar.startOfDay(for: date)
        let eligibleDays = summaries
            .filter { calendar.startOfDay(for: $0.date) < startOfTargetDay }
            .sorted { $0.date > $1.date }
            .prefix(maximumDays)

        let values = Array(eligibleDays)
        let baseline = HealthBaseline(
            hrvMilliseconds: average(values.compactMap(\.hrvMilliseconds)),
            restingHeartRate: average(values.compactMap(\.restingHeartRate)),
            sleepHours: average(values.compactMap(\.sleepHours)),
            stepCount: average(values.compactMap(\.stepCount)),
            activeEnergyKilocalories: average(values.compactMap(\.activeEnergyKilocalories)),
            workoutMinutes: average(values.compactMap(\.workoutMinutes))
        )

        return (baseline, values.count)
    }

    func hasEnoughData(days: Int, baseline: HealthBaseline) -> Bool {
        days >= minimumDays && baseline.availableMetricCount >= 3
    }

    private func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }
}
