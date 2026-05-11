import Foundation

struct DailyHealthSummary: Identifiable, Hashable {
    let date: Date
    let hrvMilliseconds: Double?
    let restingHeartRate: Double?
    let sleepHours: Double?
    let sleepEfficiency: Double?
    let stepCount: Double?
    let activeEnergyKilocalories: Double?
    let workoutMinutes: Double?
    let mindfulMinutes: Double?

    var id: Date { Calendar.current.startOfDay(for: date) }
}

struct HealthBaseline: Hashable {
    let hrvMilliseconds: Double?
    let restingHeartRate: Double?
    let sleepHours: Double?
    let stepCount: Double?
    let activeEnergyKilocalories: Double?
    let workoutMinutes: Double?

    var availableMetricCount: Int {
        [
            hrvMilliseconds,
            restingHeartRate,
            sleepHours,
            stepCount,
            activeEnergyKilocalories,
            workoutMinutes
        ].compactMap { $0 }.count
    }
}

struct RecoveryContributor: Identifiable, Hashable {
    enum Direction: String {
        case supportive = "Supportive"
        case neutral = "Neutral"
        case load = "Load"
    }

    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let impact: Int
    let direction: Direction
}

struct RecoveryScore: Hashable {
    enum Status: String {
        case ready = "Recovery signal"
        case insufficientData = "More data needed"
        case unavailable = "Unavailable"
    }

    let value: Int?
    let status: Status
    let summary: String
    let contributors: [RecoveryContributor]
    let baselineDays: Int

    static let insufficientData = RecoveryScore(
        value: nil,
        status: .insufficientData,
        summary: "Nervio needs several days of Apple Health data before estimating a recovery signal.",
        contributors: [],
        baselineDays: 0
    )
}

enum HealthPermissionState: Equatable {
    case notDetermined
    case unavailable
    case requesting
    case authorized
    case denied(String)
}

struct DashboardState: Hashable {
    let today: DailyHealthSummary?
    let baseline: HealthBaseline
    let score: RecoveryScore
    let history: [DailyHealthSummary]

    static let mock: DashboardState = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let history = (0..<21).compactMap { offset -> DailyHealthSummary? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return DailyHealthSummary(
                date: date,
                hrvMilliseconds: 48 + Double((offset % 5) * 3),
                restingHeartRate: 58 + Double(offset % 4),
                sleepHours: 6.7 + Double(offset % 4) * 0.25,
                sleepEfficiency: 0.82 + Double(offset % 3) * 0.03,
                stepCount: 7200 + Double(offset % 6) * 650,
                activeEnergyKilocalories: 430 + Double(offset % 5) * 35,
                workoutMinutes: offset % 3 == 0 ? 36 : 8,
                mindfulMinutes: offset % 4 == 0 ? 12 : 0
            )
        }.sorted { $0.date < $1.date }

        let baseline = HealthBaseline(
            hrvMilliseconds: 52,
            restingHeartRate: 60,
            sleepHours: 7.1,
            stepCount: 8400,
            activeEnergyKilocalories: 500,
            workoutMinutes: 22
        )

        let score = RecoveryScoreEngine().score(today: history.last, baseline: baseline, baselineDays: 20)
        return DashboardState(today: history.last, baseline: baseline, score: score, history: history)
    }()
}
