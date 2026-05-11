import Foundation

struct RecoveryScoreEngine {
    private let minimumBaselineDays = 7

    func score(today: DailyHealthSummary?, baseline: HealthBaseline, baselineDays: Int) -> RecoveryScore {
        guard let today else { return .insufficientData }
        guard baselineDays >= minimumBaselineDays, baseline.availableMetricCount >= 3 else {
            return RecoveryScore(
                value: nil,
                status: .insufficientData,
                summary: "Nervio needs at least a week of readable Apple Health history to form a personal baseline.",
                contributors: [],
                baselineDays: baselineDays
            )
        }

        var rawScore = 72
        var contributors: [RecoveryContributor] = []

        if let hrv = today.hrvMilliseconds, let baselineHRV = baseline.hrvMilliseconds, baselineHRV > 0 {
            let deviation = (hrv - baselineHRV) / baselineHRV
            let impact = boundedImpact(deviation * 45, limit: 18)
            rawScore += impact
            contributors.append(.init(
                title: "HRV",
                value: "\(Int(hrv.rounded())) ms",
                detail: impact >= 0 ? "Above your recent baseline, which may indicate stronger recovery signal." : "Below your recent baseline, which may indicate higher physiological load.",
                impact: impact,
                direction: direction(for: impact)
            ))
        }

        if let restingHeartRate = today.restingHeartRate, let baselineRestingHeartRate = baseline.restingHeartRate, baselineRestingHeartRate > 0 {
            let deviation = (baselineRestingHeartRate - restingHeartRate) / baselineRestingHeartRate
            let impact = boundedImpact(deviation * 40, limit: 15)
            rawScore += impact
            contributors.append(.init(
                title: "Resting heart rate",
                value: "\(Int(restingHeartRate.rounded())) bpm",
                detail: impact >= 0 ? "Near or below baseline, supporting today’s recovery signal." : "Elevated versus baseline, which may indicate added load.",
                impact: impact,
                direction: direction(for: impact)
            ))
        }

        if let sleepHours = today.sleepHours, let baselineSleepHours = baseline.sleepHours, baselineSleepHours > 0 {
            let deviation = (sleepHours - baselineSleepHours) / baselineSleepHours
            let sleepEfficiencyBonus = ((today.sleepEfficiency ?? 0.8) - 0.82) * 12
            let impact = boundedImpact(deviation * 35 + sleepEfficiencyBonus, limit: 16)
            rawScore += impact
            contributors.append(.init(
                title: "Sleep",
                value: sleepHours.formattedHours,
                detail: impact >= 0 ? "Sleep duration and quality are supportive relative to your baseline." : "Sleep appears lighter or shorter than your recent pattern.",
                impact: impact,
                direction: direction(for: impact)
            ))
        }

        if let activeEnergy = today.activeEnergyKilocalories, let baselineEnergy = baseline.activeEnergyKilocalories, baselineEnergy > 0 {
            let deviation = (activeEnergy - baselineEnergy) / baselineEnergy
            let impact = boundedImpact(-deviation * 22, limit: 12)
            rawScore += impact
            contributors.append(.init(
                title: "Active energy",
                value: "\(Int(activeEnergy.rounded())) kcal",
                detail: impact >= 0 ? "Activity load is below or near baseline today." : "Activity load is higher than baseline today.",
                impact: impact,
                direction: direction(for: impact)
            ))
        }

        if let workoutMinutes = today.workoutMinutes, let baselineWorkoutMinutes = baseline.workoutMinutes, baselineWorkoutMinutes >= 0 {
            let loadDelta = workoutMinutes - baselineWorkoutMinutes
            let impact = boundedImpact(-(loadDelta / 12), limit: 10)
            rawScore += impact
            contributors.append(.init(
                title: "Workouts",
                value: workoutMinutes.formattedMinutes,
                detail: impact >= 0 ? "Workout duration is not above your recent average." : "Workout duration is above your recent average, adding physiological load.",
                impact: impact,
                direction: direction(for: impact)
            ))
        }

        if let mindfulMinutes = today.mindfulMinutes, mindfulMinutes > 0 {
            let impact = min(6, Int((mindfulMinutes / 5).rounded()))
            rawScore += impact
            contributors.append(.init(
                title: "Mindful minutes",
                value: mindfulMinutes.formattedMinutes,
                detail: "Mindful sessions may support down-regulation and recovery routines.",
                impact: impact,
                direction: .supportive
            ))
        }

        let value = min(100, max(0, rawScore))
        return RecoveryScore(
            value: value,
            status: .ready,
            summary: summary(for: value),
            contributors: contributors,
            baselineDays: baselineDays
        )
    }

    private func boundedImpact(_ value: Double, limit: Int) -> Int {
        min(limit, max(-limit, Int(value.rounded())))
    }

    private func direction(for impact: Int) -> RecoveryContributor.Direction {
        if impact > 2 { return .supportive }
        if impact < -2 { return .load }
        return .neutral
    }

    private func summary(for value: Int) -> String {
        switch value {
        case 80...100:
            return "Available Apple Health data suggests a stronger recovery signal today."
        case 60..<80:
            return "Available Apple Health data suggests a steady recovery signal today."
        case 40..<60:
            return "Available Apple Health data suggests some added physiological load today."
        default:
            return "Available Apple Health data suggests elevated physiological load today."
        }
    }
}

private extension Double {
    var formattedHours: String {
        "\(String(format: "%.1f", self)) h"
    }

    var formattedMinutes: String {
        "\(Int(rounded())) min"
    }
}
