import Foundation

@MainActor
final class NervioAppModel: ObservableObject {
    @Published var dashboardState: DashboardState = .mock
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let baselineCalculator = BaselineCalculator()
    private let scoreEngine = RecoveryScoreEngine()

    func loadDashboard(using healthKitManager: HealthKitManager) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let summaries = try await healthKitManager.fetchDailySummaries(days: 28)
            guard let today = summaries.last else {
                dashboardState = DashboardState(
                    today: nil,
                    baseline: HealthBaseline(
                        hrvMilliseconds: nil,
                        restingHeartRate: nil,
                        sleepHours: nil,
                        stepCount: nil,
                        activeEnergyKilocalories: nil,
                        workoutMinutes: nil
                    ),
                    score: .insufficientData,
                    history: []
                )
                return
            }

            let baselineResult = baselineCalculator.baseline(from: summaries, before: today.date)
            let score = scoreEngine.score(
                today: today,
                baseline: baselineResult.baseline,
                baselineDays: baselineResult.days
            )

            dashboardState = DashboardState(
                today: today,
                baseline: baselineResult.baseline,
                score: score,
                history: summaries
            )
        } catch {
            errorMessage = "Nervio could not read Apple Health data. Check Health permissions and try again."
        }
    }
}
