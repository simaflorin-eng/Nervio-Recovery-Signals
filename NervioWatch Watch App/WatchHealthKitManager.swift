import Foundation
import HealthKit

actor WatchHealthKitManager {
    private let healthStore = HKHealthStore()
    private let calendar = Calendar.current
    private var observerQueries: [HKObserverQuery] = []

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestStepAuthorizationIfNeeded() async {
        guard canRequestHealthAuthorization,
              isHealthDataAvailable,
              let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        do {
            try await healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: [stepType])
            enableBackgroundDelivery(for: stepType)
        } catch {
            return
        }
    }

    func startObservingStepUpdates(onUpdate: @escaping @Sendable () async -> Void) async {
        guard canRequestHealthAuthorization,
              isHealthDataAvailable,
              observerQueries.isEmpty,
              let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { _, completionHandler, _ in
            Task {
                await onUpdate()
                completionHandler()
            }
        }

        observerQueries.append(query)
        healthStore.execute(query)
        enableBackgroundDelivery(for: stepType)
    }

    func stopObservingStepUpdates() {
        for query in observerQueries {
            healthStore.stop(query)
        }
        observerQueries.removeAll()
    }

    func fetchTodayAppleWatchSteps() async -> Int? {
        guard isHealthDataAvailable else { return nil }

        let endDate = Date()
        let startDate = calendar.startOfDay(for: endDate)

        do {
            let samples = try await stepSamples(startDate: startDate, endDate: endDate)
                .filter { isAppleWatchStepSample($0) }
            let total = samples.reduce(0.0) { partialResult, sample in
                partialResult + sample.quantity.doubleValue(for: .count())
            }

            return total > 0 ? Int(total.rounded()) : nil
        } catch {
            return nil
        }
    }

    private var canRequestHealthAuthorization: Bool {
        guard let usageDescription = Bundle.main.object(forInfoDictionaryKey: "NSHealthShareUsageDescription") as? String else {
            return false
        }

        return !usageDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func stepSamples(startDate: Date, endDate: Date) async throws -> [HKQuantitySample] {
        guard canRequestHealthAuthorization,
              let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return []
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: (samples ?? []).compactMap { $0 as? HKQuantitySample })
            }

            healthStore.execute(query)
        }
    }

    private func isAppleWatchStepSample(_ sample: HKQuantitySample) -> Bool {
        let sourceName = sample.sourceRevision.source.name.lowercased()
        let productType = sample.sourceRevision.productType?.lowercased() ?? ""
        let deviceName = sample.device?.name?.lowercased() ?? ""
        let deviceModel = sample.device?.model?.lowercased() ?? ""
        let localIdentifier = sample.device?.localIdentifier?.lowercased() ?? ""

        let sourceLooksLikeWatch = sourceName.contains("watch") || productType.contains("watch")
        let deviceLooksLikeWatch = deviceName.contains("watch") || deviceModel.contains("watch") || localIdentifier.contains("watch")
        let sourceLooksLikePhone = sourceName.contains("iphone") || productType.contains("iphone") || deviceModel.contains("iphone")

        return (sourceLooksLikeWatch || deviceLooksLikeWatch) && !sourceLooksLikePhone
    }

    private func enableBackgroundDelivery(for stepType: HKQuantityType) {
        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { _, _ in }
    }
}
