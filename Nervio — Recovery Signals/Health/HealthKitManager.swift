import Foundation
import HealthKit

@MainActor
final class HealthKitManager: ObservableObject {
    @Published private(set) var permissionState: HealthPermissionState = .notDetermined

    private let healthStore = HKHealthStore()
    private let calendar = Calendar.current
    private var observerQueries: [HKObserverQuery] = []

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestReadAuthorization() async {
        guard isHealthDataAvailable else {
            permissionState = .unavailable
            return
        }

        permissionState = .requesting

        do {
            try await healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: Self.readTypes)
            permissionState = .authorized
            enableBackgroundDelivery()
        } catch {
            permissionState = .denied(error.localizedDescription)
        }
    }

    func startObservingHealthUpdates(onUpdate: @escaping @MainActor () -> Void) {
        guard isHealthDataAvailable else { return }
        guard observerQueries.isEmpty else { return }

        let identifiers: [HKQuantityTypeIdentifier] = [
            .stepCount,
            .activeEnergyBurned,
            .heartRateVariabilitySDNN,
            .restingHeartRate
        ]

        for identifier in identifiers {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { continue }

            let query = HKObserverQuery(sampleType: quantityType, predicate: nil) { [weak self] _, _, completionHandler, _ in
                defer { completionHandler() }
                guard self != nil else { return }
                Task { @MainActor in
                    onUpdate()
                }
            }

            observerQueries.append(query)
            healthStore.execute(query)
            healthStore.enableBackgroundDelivery(for: quantityType, frequency: .immediate) { _, _ in }
        }
    }

    func stopObservingHealthUpdates() {
        for query in observerQueries {
            healthStore.stop(query)
        }
        observerQueries.removeAll()
    }

    func fetchDailySummaries(days: Int = 28) async throws -> [DailyHealthSummary] {
        guard isHealthDataAvailable else { return MockHealthData.dailySummaries }

        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: calendar.startOfDay(for: endDate)) else {
            return []
        }

        async let hrvSamples = quantitySamples(identifier: .heartRateVariabilitySDNN, startDate: startDate, endDate: endDate)
        async let restingHeartRateSamples = quantitySamples(identifier: .restingHeartRate, startDate: startDate, endDate: endDate)
        async let stepSamples = quantitySamples(identifier: .stepCount, startDate: startDate, endDate: endDate)
        async let activeEnergySamples = quantitySamples(identifier: .activeEnergyBurned, startDate: startDate, endDate: endDate)
        async let sleepSamples = categorySamples(identifier: .sleepAnalysis, startDate: startDate, endDate: endDate)
        async let mindfulSamples = categorySamples(identifier: .mindfulSession, startDate: startDate, endDate: endDate)
        async let workoutSamples = workoutSamples(startDate: startDate, endDate: endDate)

        return try await buildDailySummaries(
            startDate: startDate,
            endDate: endDate,
            hrvSamples: hrvSamples,
            restingHeartRateSamples: restingHeartRateSamples,
            stepSamples: stepSamples,
            activeEnergySamples: activeEnergySamples,
            sleepSamples: sleepSamples,
            mindfulSamples: mindfulSamples,
            workoutSamples: workoutSamples
        )
    }

    private static var readTypes: Set<HKObjectType> {
        var types = Set<HKObjectType>()
        let quantityIdentifiers: [HKQuantityTypeIdentifier] = [
            .heartRateVariabilitySDNN,
            .restingHeartRate,
            .stepCount,
            .activeEnergyBurned
        ]

        for identifier in quantityIdentifiers {
            if let type = HKObjectType.quantityType(forIdentifier: identifier) {
                types.insert(type)
            }
        }

        types.insert(HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        types.insert(HKObjectType.categoryType(forIdentifier: .mindfulSession)!)
        types.insert(HKObjectType.workoutType())
        return types
    }

    private func enableBackgroundDelivery() {
        guard isHealthDataAvailable else { return }

        let identifiers: [HKQuantityTypeIdentifier] = [
            .stepCount,
            .activeEnergyBurned,
            .heartRateVariabilitySDNN,
            .restingHeartRate
        ]

        for identifier in identifiers {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { continue }
            healthStore.enableBackgroundDelivery(for: quantityType, frequency: .immediate) { _, _ in }
        }
    }

    private func quantitySamples(identifier: HKQuantityTypeIdentifier, startDate: Date, endDate: Date) async throws -> [HKQuantitySample] {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: identifier) else { return [] }
        return try await samples(of: sampleType, startDate: startDate, endDate: endDate).compactMap { $0 as? HKQuantitySample }
    }

    private func categorySamples(identifier: HKCategoryTypeIdentifier, startDate: Date, endDate: Date) async throws -> [HKCategorySample] {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: identifier) else { return [] }
        return try await samples(of: sampleType, startDate: startDate, endDate: endDate).compactMap { $0 as? HKCategorySample }
    }

    private func workoutSamples(startDate: Date, endDate: Date) async throws -> [HKWorkout] {
        try await samples(of: HKObjectType.workoutType(), startDate: startDate, endDate: endDate).compactMap { $0 as? HKWorkout }
    }

    private func samples(of sampleType: HKSampleType, startDate: Date, endDate: Date) async throws -> [HKSample] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: samples ?? [])
            }

            healthStore.execute(query)
        }
    }

    private func buildDailySummaries(
        startDate: Date,
        endDate: Date,
        hrvSamples: [HKQuantitySample],
        restingHeartRateSamples: [HKQuantitySample],
        stepSamples: [HKQuantitySample],
        activeEnergySamples: [HKQuantitySample],
        sleepSamples: [HKCategorySample],
        mindfulSamples: [HKCategorySample],
        workoutSamples: [HKWorkout]
    ) -> [DailyHealthSummary] {
        days(from: startDate, through: endDate).map { day in
            let interval = dayInterval(for: day)
            return DailyHealthSummary(
                date: day,
                hrvMilliseconds: averageQuantity(hrvSamples, unit: .secondUnit(with: .milli), in: interval),
                restingHeartRate: averageQuantity(restingHeartRateSamples, unit: HKUnit.count().unitDivided(by: .minute()), in: interval),
                sleepHours: sleepHours(from: sleepSamples, in: interval),
                sleepEfficiency: sleepEfficiency(from: sleepSamples, in: interval),
                stepCount: sumQuantity(stepSamples, unit: .count(), in: interval),
                activeEnergyKilocalories: sumQuantity(activeEnergySamples, unit: .kilocalorie(), in: interval),
                workoutMinutes: minutes(from: workoutSamples, in: interval),
                mindfulMinutes: minutes(from: mindfulSamples, in: interval)
            )
        }
    }

    private func days(from startDate: Date, through endDate: Date) -> [Date] {
        var days: [Date] = []
        var current = calendar.startOfDay(for: startDate)
        let final = calendar.startOfDay(for: endDate)

        while current <= final {
            days.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }

        return days
    }

    private func dayInterval(for date: Date) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        return DateInterval(start: start, end: end)
    }

    private func averageQuantity(_ samples: [HKQuantitySample], unit: HKUnit, in interval: DateInterval) -> Double? {
        let values = samples
            .filter { interval.contains($0.startDate) }
            .map { $0.quantity.doubleValue(for: unit) }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private func sumQuantity(_ samples: [HKQuantitySample], unit: HKUnit, in interval: DateInterval) -> Double? {
        let values = samples
            .filter { interval.contains($0.startDate) }
            .map { $0.quantity.doubleValue(for: unit) }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +)
    }

    private func sleepHours(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let seconds = samples
            .filter { isAsleep($0.value) }
            .reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        return seconds > 0 ? seconds / 3600 : nil
    }

    private func sleepEfficiency(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let asleepSeconds = samples
            .filter { isAsleep($0.value) }
            .reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        let inBedSeconds = samples
            .filter { $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue }
            .reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }

        guard asleepSeconds > 0, inBedSeconds > 0 else { return nil }
        return min(1, asleepSeconds / inBedSeconds)
    }

    private func minutes(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let seconds = samples.reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        return seconds > 0 ? seconds / 60 : nil
    }

    private func minutes(from workouts: [HKWorkout], in interval: DateInterval) -> Double? {
        let seconds = workouts.reduce(0) { total, workout in
            total + overlapSeconds(startDate: workout.startDate, endDate: workout.endDate, interval: interval)
        }
        return seconds > 0 ? seconds / 60 : nil
    }

    private func overlapSeconds(sample: HKSample, interval: DateInterval) -> TimeInterval {
        overlapSeconds(startDate: sample.startDate, endDate: sample.endDate, interval: interval)
    }

    private func overlapSeconds(startDate: Date, endDate: Date, interval: DateInterval) -> TimeInterval {
        let start = max(startDate, interval.start)
        let end = min(endDate, interval.end)
        return max(0, end.timeIntervalSince(start))
    }

    private func isAsleep(_ value: Int) -> Bool {
        let sleepValue = HKCategoryValueSleepAnalysis(rawValue: value)
        return sleepValue == .asleepUnspecified || sleepValue == .asleepCore || sleepValue == .asleepDeep || sleepValue == .asleepREM
    }
}

enum MockHealthData {
    static var dailySummaries: [DailyHealthSummary] {
        DashboardState.mock.history
    }
}
