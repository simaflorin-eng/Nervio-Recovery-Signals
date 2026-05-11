import Charts
import HealthKit
import Observation
import SwiftUI

enum L10n {
    static func string(_ key: String) -> String {
        if let value = inAppTranslation(for: key) {
            return value
        }

        if let bundle = selectedLanguageBundle {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }

        return String(localized: String.LocalizationValue(key))
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: string(key), locale: .current, arguments: arguments)
    }

    private static var selectedLanguageBundle: Bundle? {
        let code = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? AppLanguage.system.rawValue
        guard code != AppLanguage.system.rawValue,
              let path = Bundle.main.path(forResource: code, ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }

    private static func inAppTranslation(for key: String) -> String? {
        let code = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? AppLanguage.system.rawValue
        guard code != AppLanguage.system.rawValue, code != AppLanguage.en.rawValue else {
            return nil
        }

        return inAppTranslations[code]?[key]
    }

    private static let inAppTranslations: [String: [String: String]] = [
        "ro": [
            "Today": "Azi",
            "Trends": "Tendințe",
            "Settings": "Setări",
            "Privacy": "Confidențialitate",
            "Language": "Limbă",
            "Appearance": "Aspect",
            "Theme": "Temă",
            "System": "Sistem",
            "Light": "Luminos",
            "Dark": "Întunecat",
            "More data needed": "Sunt necesare mai multe date",
            "Health data status": "Starea datelor de sănătate",
            "Refresh Health data": "Reîmprospătează datele de sănătate",
            "Stress / load score": "Scor stres / încărcare",
            "Today’s inputs": "Datele de azi",
            "Resting HR": "RC repaus",
            "Sleep": "Somn",
            "Active energy": "Energie activă",
            "Score contributors": "Contribuitori la scor",
            "Apple Health": "Apple Health",
            "Permission": "Permisiune",
            "Request Health Access": "Solicită acces la Sănătate",
            "Onboarding": "Introducere",
            "Show Onboarding Again": "Afișează din nou introducerea",
            "Not requested": "Nesolicitat",
            "Requesting": "Se solicită",
            "Requested": "Solicitat",
            "Needs review": "Necesită verificare"
        ],
        "fr": [
            "Today": "Aujourd’hui",
            "Trends": "Tendances",
            "Settings": "Réglages",
            "Privacy": "Confidentialité",
            "Language": "Langue",
            "Appearance": "Apparence",
            "Theme": "Thème",
            "System": "Système",
            "Light": "Clair",
            "Dark": "Sombre",
            "More data needed": "Plus de données nécessaires",
            "Health data status": "État des données de santé",
            "Refresh Health data": "Actualiser les données de santé",
            "Stress / load score": "Score stress / charge",
            "Today’s inputs": "Données du jour",
            "Resting HR": "FC repos",
            "Sleep": "Sommeil",
            "Active energy": "Énergie active",
            "Score contributors": "Contributeurs du score",
            "Apple Health": "Apple Health",
            "Permission": "Autorisation",
            "Request Health Access": "Demander l’accès Santé",
            "Onboarding": "Introduction",
            "Show Onboarding Again": "Afficher à nouveau l’introduction",
            "Not requested": "Non demandé",
            "Requesting": "Demande en cours",
            "Requested": "Demandé",
            "Needs review": "À vérifier"
        ],
        "de": [
            "Today": "Heute",
            "Trends": "Trends",
            "Settings": "Einstellungen",
            "Privacy": "Datenschutz",
            "Language": "Sprache",
            "Appearance": "Darstellung",
            "Theme": "Design",
            "System": "System",
            "Light": "Hell",
            "Dark": "Dunkel",
            "More data needed": "Mehr Daten erforderlich",
            "Health data status": "Status der Gesundheitsdaten",
            "Refresh Health data": "Gesundheitsdaten aktualisieren",
            "Stress / load score": "Stress-/Belastungsscore",
            "Today’s inputs": "Heutige Eingaben",
            "Resting HR": "Ruhepuls",
            "Sleep": "Schlaf",
            "Active energy": "Aktive Energie",
            "Score contributors": "Score-Beiträge",
            "Apple Health": "Apple Health",
            "Permission": "Berechtigung",
            "Request Health Access": "Health-Zugriff anfordern",
            "Onboarding": "Einführung",
            "Show Onboarding Again": "Einführung erneut anzeigen",
            "Not requested": "Nicht angefordert",
            "Requesting": "Wird angefordert",
            "Requested": "Angefordert",
            "Needs review": "Überprüfung nötig"
        ],
        "es": [
            "Today": "Hoy",
            "Trends": "Tendencias",
            "Settings": "Ajustes",
            "Privacy": "Privacidad",
            "Language": "Idioma",
            "Appearance": "Apariencia",
            "Theme": "Tema",
            "System": "Sistema",
            "Light": "Claro",
            "Dark": "Oscuro",
            "More data needed": "Se necesitan más datos",
            "Health data status": "Estado de los datos de salud",
            "Refresh Health data": "Actualizar datos de salud",
            "Stress / load score": "Puntuación de estrés / carga",
            "Today’s inputs": "Datos de hoy",
            "Resting HR": "FC reposo",
            "Sleep": "Sueño",
            "Active energy": "Energía activa",
            "Score contributors": "Contribuidores de la puntuación",
            "Apple Health": "Apple Health",
            "Permission": "Permiso",
            "Request Health Access": "Solicitar acceso a Salud",
            "Onboarding": "Introducción",
            "Show Onboarding Again": "Mostrar introducción de nuevo",
            "Not requested": "No solicitado",
            "Requesting": "Solicitando",
            "Requested": "Solicitado",
            "Needs review": "Requiere revisión"
        ],
        "it": [
            "Today": "Oggi",
            "Trends": "Tendenze",
            "Settings": "Impostazioni",
            "Privacy": "Privacy",
            "Language": "Lingua",
            "Appearance": "Aspetto",
            "Theme": "Tema",
            "System": "Sistema",
            "Light": "Chiaro",
            "Dark": "Scuro",
            "More data needed": "Servono più dati",
            "Health data status": "Stato dei dati sanitari",
            "Refresh Health data": "Aggiorna dati sanitari",
            "Stress / load score": "Punteggio stress / carico",
            "Today’s inputs": "Dati di oggi",
            "Resting HR": "FC a riposo",
            "Sleep": "Sonno",
            "Active energy": "Energia attiva",
            "Score contributors": "Contributori del punteggio",
            "Apple Health": "Apple Health",
            "Permission": "Autorizzazione",
            "Request Health Access": "Richiedi accesso a Salute",
            "Onboarding": "Introduzione",
            "Show Onboarding Again": "Mostra di nuovo l’introduzione",
            "Not requested": "Non richiesto",
            "Requesting": "Richiesta in corso",
            "Requested": "Richiesto",
            "Needs review": "Da verificare"
        ],
        "pt": [
            "Today": "Hoje",
            "Trends": "Tendências",
            "Settings": "Definições",
            "Privacy": "Privacidade",
            "Language": "Idioma",
            "Appearance": "Aparência",
            "Theme": "Tema",
            "System": "Sistema",
            "Light": "Claro",
            "Dark": "Escuro",
            "More data needed": "São necessários mais dados",
            "Health data status": "Estado dos dados de saúde",
            "Refresh Health data": "Atualizar dados de saúde",
            "Stress / load score": "Pontuação de stress / carga",
            "Today’s inputs": "Dados de hoje",
            "Resting HR": "FC repouso",
            "Sleep": "Sono",
            "Active energy": "Energia ativa",
            "Score contributors": "Contribuidores da pontuação",
            "Apple Health": "Apple Health",
            "Permission": "Permissão",
            "Request Health Access": "Pedir acesso à Saúde",
            "Onboarding": "Introdução",
            "Show Onboarding Again": "Mostrar introdução novamente",
            "Not requested": "Não solicitado",
            "Requesting": "A solicitar",
            "Requested": "Solicitado",
            "Needs review": "Precisa de revisão"
        ]
    ]
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case en
    case ro
    case fr
    case de
    case es
    case it
    case pt

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: L10n.string("System")
        case .en: "English"
        case .ro: "Română"
        case .fr: "Français"
        case .de: "Deutsch"
        case .es: "Español"
        case .it: "Italiano"
        case .pt: "Português"
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: L10n.string("System")
        case .light: L10n.string("Light")
        case .dark: L10n.string("Dark")
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedLanguageCode") private var selectedLanguageCode = AppLanguage.system.rawValue
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    @State private var healthKitManager = HealthKitManager()
    @State private var appModel = NervioAppModel()

    private var appTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView(
                    healthKitManager: healthKitManager,
                    appModel: appModel,
                    selectedLanguageCode: $selectedLanguageCode,
                    selectedTheme: $selectedTheme,
                    onRefresh: refreshDashboard,
                    onResetOnboarding: { hasCompletedOnboarding = false }
                )
            } else {
                OnboardingView(
                    permissionState: healthKitManager.permissionState,
                    isLoading: appModel.isLoading,
                    onContinue: completeOnboardingWithHealthAccess,
                    onUsePreviewData: {
                        appModel.dashboardState = .mock
                        hasCompletedOnboarding = true
                    }
                )
            }
        }
        .id(selectedLanguageCode)
        .preferredColorScheme(appTheme.colorScheme)
        .task {
            guard hasCompletedOnboarding else { return }
            await refreshDashboard()
        }
    }

    private func completeOnboardingWithHealthAccess() async {
        await healthKitManager.requestReadAuthorization()
        await refreshDashboard()
        hasCompletedOnboarding = true
    }

    private func refreshDashboard() async {
        await appModel.loadDashboard(using: healthKitManager)
    }
}

@MainActor
@Observable
final class NervioAppModel {
    var dashboardState: DashboardState = .mock
    var isLoading = false
    var errorMessage: String?

    private let baselineCalculator = BaselineCalculator()
    private let scoreEngine = RecoveryScoreEngine()

    func loadDashboard(using healthKitManager: HealthKitManager) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let summaries = try await healthKitManager.fetchDailySummaries(days: 28)
            guard let today = summaries.last else {
                dashboardState = DashboardState(today: nil, baseline: .empty, score: .insufficientData, stressScore: .insufficientData, history: [])
                errorMessage = L10n.string("No Apple Health samples were returned for the selected period. Open the Health app and confirm this iPhone has data for HRV, resting heart rate, sleep, steps, active energy, workouts, or mindful sessions.")
                return
            }

            if !summaries.contains(where: { $0.hasReadableHealthValue }) {
                dashboardState = DashboardState(today: today, baseline: .empty, score: .insufficientData, stressScore: .insufficientData, history: summaries)
                errorMessage = L10n.string("Apple Health access is connected, but no readable samples were returned yet. Check that individual Health permissions are enabled and that this device has recent Health data.")
                return
            }

            let baselineResult = baselineCalculator.baseline(from: summaries, before: today.date)
            let score = scoreEngine.score(today: today, baseline: baselineResult.baseline, baselineDays: baselineResult.days)
            let stressScore = scoreEngine.stressScore(today: today, baseline: baselineResult.baseline, baselineDays: baselineResult.days)
            dashboardState = DashboardState(today: today, baseline: baselineResult.baseline, score: score, stressScore: stressScore, history: summaries)
        } catch {
            errorMessage = L10n.string("Nervio could not read Apple Health data. Check Health permissions and try again.")
        }
    }
}

@MainActor
@Observable
final class HealthKitManager {
    private(set) var permissionState: HealthPermissionState = .notDetermined

    private let healthStore = HKHealthStore()
    private let calendar = Calendar.current

    var isHealthDataAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    private var hasHealthShareUsageDescription: Bool {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "NSHealthShareUsageDescription") as? String else {
            return false
        }
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func requestReadAuthorization() async {
        guard isHealthDataAvailable else {
            permissionState = .unavailable
            return
        }

        guard hasHealthShareUsageDescription else {
            permissionState = .denied(L10n.string("Missing NSHealthShareUsageDescription in the app target. Add the Health privacy usage description before requesting Apple Health access."))
            return
        }

        permissionState = .requesting
        do {
            try await healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: Self.readTypes)
            permissionState = .authorized
        } catch {
            permissionState = .denied(error.localizedDescription)
        }
    }

    func fetchDailySummaries(days: Int = 28) async throws -> [DailyHealthSummary] {
        guard isHealthDataAvailable else { return MockHealthData.dailySummaries }

        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: calendar.startOfDay(for: endDate)) else { return [] }

        async let hrvSamples = safeQuantitySamples(identifier: .heartRateVariabilitySDNN, startDate: startDate, endDate: endDate)
        async let restingHeartRateSamples = safeQuantitySamples(identifier: .restingHeartRate, startDate: startDate, endDate: endDate)
        async let stepSamples = safeQuantitySamples(identifier: .stepCount, startDate: startDate, endDate: endDate)
        async let activeEnergySamples = safeQuantitySamples(identifier: .activeEnergyBurned, startDate: startDate, endDate: endDate)
        async let sleepSamples = safeCategorySamples(identifier: .sleepAnalysis, startDate: startDate, endDate: endDate)
        async let mindfulSamples = safeCategorySamples(identifier: .mindfulSession, startDate: startDate, endDate: endDate)
        async let workouts = safeWorkoutSamples(startDate: startDate, endDate: endDate)

        return await buildDailySummaries(
            startDate: startDate,
            endDate: endDate,
            hrvSamples: hrvSamples,
            restingHeartRateSamples: restingHeartRateSamples,
            stepSamples: stepSamples,
            activeEnergySamples: activeEnergySamples,
            sleepSamples: sleepSamples,
            mindfulSamples: mindfulSamples,
            workoutSamples: workouts
        )
    }

    private static var readTypes: Set<HKObjectType> {
        var types = Set<HKObjectType>()
        [HKQuantityTypeIdentifier.heartRateVariabilitySDNN, .restingHeartRate, .stepCount, .activeEnergyBurned].forEach { identifier in
            if let type = HKObjectType.quantityType(forIdentifier: identifier) { types.insert(type) }
        }
        types.insert(HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        types.insert(HKObjectType.categoryType(forIdentifier: .mindfulSession)!)
        types.insert(HKObjectType.workoutType())
        return types
    }

    private func quantitySamples(identifier: HKQuantityTypeIdentifier, startDate: Date, endDate: Date) async throws -> [HKQuantitySample] {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: identifier) else { return [] }
        return try await samples(of: sampleType, startDate: startDate, endDate: endDate).compactMap { $0 as? HKQuantitySample }
    }

    private func safeQuantitySamples(identifier: HKQuantityTypeIdentifier, startDate: Date, endDate: Date) async -> [HKQuantitySample] {
        do {
            return try await quantitySamples(identifier: identifier, startDate: startDate, endDate: endDate)
        } catch {
            return []
        }
    }

    private func categorySamples(identifier: HKCategoryTypeIdentifier, startDate: Date, endDate: Date) async throws -> [HKCategorySample] {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: identifier) else { return [] }
        return try await samples(of: sampleType, startDate: startDate, endDate: endDate).compactMap { $0 as? HKCategorySample }
    }

    private func safeCategorySamples(identifier: HKCategoryTypeIdentifier, startDate: Date, endDate: Date) async -> [HKCategorySample] {
        do {
            return try await categorySamples(identifier: identifier, startDate: startDate, endDate: endDate)
        } catch {
            return []
        }
    }

    private func workoutSamples(startDate: Date, endDate: Date) async throws -> [HKWorkout] {
        try await samples(of: HKObjectType.workoutType(), startDate: startDate, endDate: endDate).compactMap { $0 as? HKWorkout }
    }

    private func safeWorkoutSamples(startDate: Date, endDate: Date) async -> [HKWorkout] {
        do {
            return try await workoutSamples(startDate: startDate, endDate: endDate)
        } catch {
            return []
        }
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
        let values = samples.filter { interval.contains($0.startDate) }.map { $0.quantity.doubleValue(for: unit) }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private func sumQuantity(_ samples: [HKQuantitySample], unit: HKUnit, in interval: DateInterval) -> Double? {
        let values = samples.filter { interval.contains($0.startDate) }.map { $0.quantity.doubleValue(for: unit) }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +)
    }

    private func sleepHours(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let seconds = samples.filter { isAsleep($0.value) }.reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        return seconds > 0 ? seconds / 3600 : nil
    }

    private func sleepEfficiency(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let asleepSeconds = samples.filter { isAsleep($0.value) }.reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        let inBedSeconds = samples.filter { $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue }.reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        guard asleepSeconds > 0, inBedSeconds > 0 else { return nil }
        return min(1, asleepSeconds / inBedSeconds)
    }

    private func minutes(from samples: [HKCategorySample], in interval: DateInterval) -> Double? {
        let seconds = samples.reduce(0) { $0 + overlapSeconds(sample: $1, interval: interval) }
        return seconds > 0 ? seconds / 60 : nil
    }

    private func minutes(from workouts: [HKWorkout], in interval: DateInterval) -> Double? {
        let seconds = workouts.reduce(0) { $0 + overlapSeconds(startDate: $1.startDate, endDate: $1.endDate, interval: interval) }
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
        let values = Array(summaries.filter { calendar.startOfDay(for: $0.date) < startOfTargetDay }.sorted { $0.date > $1.date }.prefix(maximumDays))
        return (HealthBaseline(
            hrvMilliseconds: average(values.compactMap(\.hrvMilliseconds)),
            restingHeartRate: average(values.compactMap(\.restingHeartRate)),
            sleepHours: average(values.compactMap(\.sleepHours)),
            stepCount: average(values.compactMap(\.stepCount)),
            activeEnergyKilocalories: average(values.compactMap(\.activeEnergyKilocalories)),
            workoutMinutes: average(values.compactMap(\.workoutMinutes))
        ), values.count)
    }

    func hasEnoughData(days: Int, baseline: HealthBaseline) -> Bool {
        days >= minimumDays && baseline.availableMetricCount >= 3
    }

    private func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }
}

struct RecoveryScoreEngine {
    private let minimumBaselineDays = 7

    func score(today: DailyHealthSummary?, baseline: HealthBaseline, baselineDays: Int) -> RecoveryScore {
        guard let today else { return .insufficientData }
        guard baselineDays >= minimumBaselineDays, baseline.availableMetricCount >= 3 else {
            return RecoveryScore(value: nil, status: .insufficientData, summary: L10n.string("Nervio needs at least a week of readable Apple Health history to form a personal baseline."), contributors: [], baselineDays: baselineDays)
        }

        let contributors = recoveryContributors(today: today, baseline: baseline)
        let rawScore = 70 + contributors.reduce(0) { $0 + $1.impact }
        let value = min(100, max(0, rawScore))
        return RecoveryScore(value: value, status: .ready, summary: summary(for: value), contributors: contributors, baselineDays: baselineDays)
    }

    func stressScore(today: DailyHealthSummary?, baseline: HealthBaseline, baselineDays: Int) -> StressScore {
        guard let today else { return .insufficientData }
        guard baselineDays >= minimumBaselineDays, baseline.availableMetricCount >= 3 else {
            return StressScore(value: nil, summary: L10n.string("Nervio needs at least a week of readable Apple Health history to estimate physiological load."), baselineDays: baselineDays)
        }

        let contributors = recoveryContributors(today: today, baseline: baseline)
        let negativeRecoveryImpact = contributors.reduce(0) { $0 + max(0, -$1.impact) }
        let supportiveImpact = contributors.reduce(0) { $0 + max(0, $1.impact) }
        let activityLoadImpact = activityLoadContributors(today: today, baseline: baseline)
        let rawScore = 35 + Int((Double(negativeRecoveryImpact) * 1.35).rounded()) + activityLoadImpact - Int((Double(supportiveImpact) * 0.45).rounded())
        let value = min(100, max(0, rawScore))
        return StressScore(value: value, summary: stressSummary(for: value), baselineDays: baselineDays)
    }

    private func recoveryContributors(today: DailyHealthSummary, baseline: HealthBaseline) -> [RecoveryContributor] {
        var contributors: [RecoveryContributor] = []

        if let hrv = today.hrvMilliseconds, let baselineHRV = baseline.hrvMilliseconds, baselineHRV > 0 {
            let impact = boundedImpact(((hrv - baselineHRV) / baselineHRV) * 45, limit: 18)
            contributors.append(.init(title: L10n.string("HRV"), value: "\(Int(hrv.rounded())) ms", detail: impact >= 0 ? L10n.string("Above your recent baseline, which may indicate stronger recovery signal.") : L10n.string("Below your recent baseline, which may indicate higher physiological load."), impact: impact, direction: direction(for: impact)))
        }

        if let rhr = today.restingHeartRate, let baselineRHR = baseline.restingHeartRate, baselineRHR > 0 {
            let impact = boundedImpact(((baselineRHR - rhr) / baselineRHR) * 40, limit: 15)
            contributors.append(.init(title: L10n.string("Resting heart rate"), value: "\(Int(rhr.rounded())) bpm", detail: impact >= 0 ? L10n.string("Near or below baseline, supporting today’s recovery signal.") : L10n.string("Elevated versus baseline, which may indicate added load."), impact: impact, direction: direction(for: impact)))
        }

        if let sleep = today.sleepHours, let baselineSleep = baseline.sleepHours, baselineSleep > 0 {
            let efficiencyBonus = ((today.sleepEfficiency ?? 0.8) - 0.82) * 12
            let impact = boundedImpact(((sleep - baselineSleep) / baselineSleep) * 35 + efficiencyBonus, limit: 16)
            contributors.append(.init(title: L10n.string("Sleep"), value: sleep.formattedHours, detail: impact >= 0 ? L10n.string("Sleep duration and quality are supportive relative to your baseline.") : L10n.string("Sleep appears lighter or shorter than your recent pattern."), impact: impact, direction: direction(for: impact)))
        }

        if let energy = today.activeEnergyKilocalories, let baselineEnergy = baseline.activeEnergyKilocalories, baselineEnergy > 0 {
            let impact = boundedImpact(-((energy - baselineEnergy) / baselineEnergy) * 22, limit: 12)
            contributors.append(.init(title: L10n.string("Active energy"), value: "\(Int(energy.rounded())) kcal", detail: impact >= 0 ? L10n.string("Activity load is below or near baseline today.") : L10n.string("Activity load is higher than baseline today."), impact: impact, direction: direction(for: impact)))
        }

        if let workout = today.workoutMinutes, let baselineWorkout = baseline.workoutMinutes {
            let impact = boundedImpact(-((workout - baselineWorkout) / 12), limit: 10)
            contributors.append(.init(title: L10n.string("Workouts"), value: workout.formattedMinutes, detail: impact >= 0 ? L10n.string("Workout duration is not above your recent average.") : L10n.string("Workout duration is above your recent average, adding physiological load."), impact: impact, direction: direction(for: impact)))
        }

        if let mindful = today.mindfulMinutes, mindful > 0 {
            let impact = min(6, Int((mindful / 5).rounded()))
            contributors.append(.init(title: L10n.string("Mindful minutes"), value: mindful.formattedMinutes, detail: L10n.string("Mindful sessions may support down-regulation and recovery routines."), impact: impact, direction: .supportive))
        }

        return contributors
    }

    private func activityLoadContributors(today: DailyHealthSummary, baseline: HealthBaseline) -> Int {
        var load = 0

        if let energy = today.activeEnergyKilocalories, let baselineEnergy = baseline.activeEnergyKilocalories, baselineEnergy > 0 {
            load += max(0, boundedImpact(((energy - baselineEnergy) / baselineEnergy) * 18, limit: 10))
        }

        if let workout = today.workoutMinutes, let baselineWorkout = baseline.workoutMinutes {
            load += max(0, boundedImpact((workout - baselineWorkout) / 10, limit: 8))
        }

        return load
    }

    private func boundedImpact(_ value: Double, limit: Int) -> Int { min(limit, max(-limit, Int(value.rounded()))) }

    private func direction(for impact: Int) -> RecoveryContributor.Direction {
        if impact > 2 { return .supportive }
        if impact < -2 { return .load }
        return .neutral
    }

    private func summary(for value: Int) -> String {
        switch value {
        case 80...100: L10n.string("Available Apple Health data suggests a stronger recovery signal today.")
        case 60..<80: L10n.string("Available Apple Health data suggests a steady recovery signal today.")
        case 40..<60: L10n.string("Available Apple Health data suggests some added physiological load today.")
        default: L10n.string("Available Apple Health data suggests elevated physiological load today.")
        }
    }

    private func stressSummary(for value: Int) -> String {
        switch value {
        case 75...100: L10n.string("Available data suggests physiological load may be elevated today.")
        case 50..<75: L10n.string("Available data suggests a moderate physiological load signal today.")
        case 25..<50: L10n.string("Available data suggests a lower physiological load signal today.")
        default: L10n.string("Available data suggests a very low physiological load signal today.")
        }
    }
}

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

    var hasReadableHealthValue: Bool {
        hrvMilliseconds != nil ||
        restingHeartRate != nil ||
        sleepHours != nil ||
        sleepEfficiency != nil ||
        stepCount != nil ||
        activeEnergyKilocalories != nil ||
        workoutMinutes != nil ||
        mindfulMinutes != nil
    }
}

struct HealthBaseline: Hashable {
    let hrvMilliseconds: Double?
    let restingHeartRate: Double?
    let sleepHours: Double?
    let stepCount: Double?
    let activeEnergyKilocalories: Double?
    let workoutMinutes: Double?

    static let empty = HealthBaseline(hrvMilliseconds: nil, restingHeartRate: nil, sleepHours: nil, stepCount: nil, activeEnergyKilocalories: nil, workoutMinutes: nil)

    var availableMetricCount: Int {
        [hrvMilliseconds, restingHeartRate, sleepHours, stepCount, activeEnergyKilocalories, workoutMinutes].compactMap { $0 }.count
    }
}

struct RecoveryContributor: Identifiable, Hashable {
    enum Direction: String {
        case supportive = "Supportive"
        case neutral = "Neutral"
        case load = "Load"

        var localizedTitle: String {
            L10n.string(rawValue)
        }
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

        var localizedTitle: String {
            L10n.string(rawValue)
        }
    }

    let value: Int?
    let status: Status
    let summary: String
    let contributors: [RecoveryContributor]
    let baselineDays: Int

    static let insufficientData = RecoveryScore(value: nil, status: .insufficientData, summary: L10n.string("Nervio needs several days of Apple Health data before estimating a recovery signal."), contributors: [], baselineDays: 0)
}

struct StressScore: Hashable {
    let value: Int?
    let summary: String
    let baselineDays: Int

    static let insufficientData = StressScore(value: nil, summary: L10n.string("Nervio needs several days of Apple Health data before estimating physiological load."), baselineDays: 0)
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
    let stressScore: StressScore
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

        let baseline = HealthBaseline(hrvMilliseconds: 52, restingHeartRate: 60, sleepHours: 7.1, stepCount: 8400, activeEnergyKilocalories: 500, workoutMinutes: 22)
        let engine = RecoveryScoreEngine()
        let score = engine.score(today: history.last, baseline: baseline, baselineDays: 20)
        let stressScore = engine.stressScore(today: history.last, baseline: baseline, baselineDays: 20)
        return DashboardState(today: history.last, baseline: baseline, score: score, stressScore: stressScore, history: history)
    }()
}

enum MockHealthData {
    static var dailySummaries: [DailyHealthSummary] { DashboardState.mock.history }
}

struct OnboardingView: View {
    let permissionState: HealthPermissionState
    let isLoading: Bool
    let onContinue: () async -> Void
    let onUsePreviewData: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 28) {
                Spacer(minLength: 24)
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "waveform.path.ecg.rectangle")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(.teal)
                    Text(L10n.string("Nervio"))
                        .font(.largeTitle.bold())
                    Text(L10n.string("Recovery and nervous system insights based on available Apple Health data."))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                VStack(spacing: 14) {
                    OnboardingPoint(icon: "lock.shield", title: L10n.string("Private by design"), detail: L10n.string("Your health data never leaves your iPhone."))
                    OnboardingPoint(icon: "heart.text.square", title: L10n.string("Read-only Health access"), detail: L10n.string("Nervio reads HRV, resting heart rate, sleep, activity, workouts, and mindful sessions."))
                    OnboardingPoint(icon: "chart.line.uptrend.xyaxis", title: L10n.string("Transparent signals"), detail: L10n.string("Scores compare today with your own recent baseline and avoid medical conclusions."))
                }
                Spacer()
                VStack(spacing: 12) {
                    Button {
                        Task { await onContinue() }
                    } label: {
                        Label(isLoading ? L10n.string("Loading") : L10n.string("Connect Apple Health"), systemImage: "heart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(isLoading || permissionState == .requesting)

                    Button(L10n.string("Use Preview Data"), action: onUsePreviewData)
                        .buttonStyle(.borderless)
                    permissionMessage
                }
            }
            .padding(24)
        }
    }

    @ViewBuilder
    private var permissionMessage: some View {
        switch permissionState {
        case .unavailable:
            Text(L10n.string("Apple Health is unavailable on this device. Preview data is shown in Simulator."))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        case .denied(let message):
            Text(L10n.format("Health access was not granted. %@", message))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        default:
            EmptyView()
        }
    }
}

private struct OnboardingPoint: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.teal)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MainTabView: View {
    let healthKitManager: HealthKitManager
    let appModel: NervioAppModel
    @Binding var selectedLanguageCode: String
    @Binding var selectedTheme: String
    let onRefresh: () async -> Void
    let onResetOnboarding: () -> Void

    var body: some View {
        TabView {
            DashboardView(dashboardState: appModel.dashboardState, permissionState: healthKitManager.permissionState, isLoading: appModel.isLoading, errorMessage: appModel.errorMessage, onRefresh: onRefresh)
                .tabItem { Label(L10n.string("Today"), systemImage: "gauge.with.dots.needle.67percent") }
            TrendsView(dashboardState: appModel.dashboardState)
                .tabItem { Label(L10n.string("Trends"), systemImage: "chart.xyaxis.line") }
            AppSettingsView(
                selectedLanguageCode: $selectedLanguageCode,
                selectedTheme: $selectedTheme
            )
            .tabItem { Label(L10n.string("Settings"), systemImage: "gearshape") }
            PrivacySettingsView(permissionState: healthKitManager.permissionState, onRequestAccess: {
                await healthKitManager.requestReadAuthorization()
                await onRefresh()
            }, onResetOnboarding: onResetOnboarding)
            .tabItem { Label(L10n.string("Privacy"), systemImage: "lock.shield") }
        }
    }
}

struct AppSettingsView: View {
    @Binding var selectedLanguageCode: String
    @Binding var selectedTheme: String

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.string("Language")) {
                    Picker(L10n.string("Language"), selection: $selectedLanguageCode) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.title).tag(language.rawValue)
                        }
                    }
                }

                Section(L10n.string("Appearance")) {
                    Picker(L10n.string("Theme"), selection: $selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.title).tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(L10n.string("Settings"))
        }
    }
}

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
                    StressScoreCard(stressScore: dashboardState.stressScore)
                    if let errorMessage {
                        MessageBanner(icon: "exclamationmark.triangle", title: L10n.string("Health data status"), message: errorMessage)
                    } else if dashboardState.score.status == .insufficientData {
                        MessageBanner(icon: "calendar.badge.clock", title: L10n.string("More data needed"), message: dashboardState.score.summary)
                    }
                    TodayMetricsView(summary: dashboardState.today)
                    ContributorsView(contributors: dashboardState.score.contributors)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L10n.string("Today"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await onRefresh() } } label: { Image(systemName: "arrow.clockwise") }
                        .disabled(isLoading)
                        .accessibilityLabel(L10n.string("Refresh Health data"))
                }
            }
            .refreshable { await onRefresh() }
        }
    }
}

private struct ScoreHeader: View {
    let score: RecoveryScore

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(score.status.localizedTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(score.summary)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 16)
                ZStack {
                    Circle().stroke(.teal.opacity(0.16), lineWidth: 12)
                    Circle()
                        .trim(from: 0, to: CGFloat(score.value ?? 0) / 100)
                        .stroke(.teal, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text(score.value.map(String.init) ?? "--")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                }
                .frame(width: 104, height: 104)
            }
            Text(L10n.format("Based on %d baseline days. This is a wellness signal, not a diagnosis or medical conclusion.", score.baselineDays))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct StressScoreCard: View {
    let stressScore: StressScore

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle().stroke(.orange.opacity(0.16), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(stressScore.value ?? 0) / 100)
                    .stroke(.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(stressScore.value.map(String.init) ?? "--")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
            }
            .frame(width: 82, height: 82)

            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.string("Stress / load score"))
                    .font(.headline)
                Text(stressScore.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(L10n.string("Higher means available data may indicate more physiological load."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct TodayMetricsView: View {
    let summary: DailyHealthSummary?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.string("Today’s inputs")).font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricTile(title: L10n.string("HRV"), value: summary?.hrvMilliseconds.map { "\(Int($0.rounded())) ms" } ?? "--", icon: "waveform.path.ecg")
                MetricTile(title: L10n.string("Resting HR"), value: summary?.restingHeartRate.map { "\(Int($0.rounded())) bpm" } ?? "--", icon: "heart")
                MetricTile(title: L10n.string("Sleep"), value: summary?.sleepHours.map { String(format: "%.1f h", $0) } ?? "--", icon: "bed.double")
                MetricTile(title: L10n.string("Active energy"), value: summary?.activeEnergyKilocalories.map { "\(Int($0.rounded())) kcal" } ?? "--", icon: "flame")
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
            Image(systemName: icon).foregroundStyle(.teal)
            Text(value).font(.title3.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.75)
            Text(title).font(.caption).foregroundStyle(.secondary)
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
            Text(L10n.string("Score contributors")).font(.headline)
            if contributors.isEmpty {
                Text(L10n.string("Contributors will appear after Nervio can compare today with your rolling baseline."))
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
                                Text(contributor.title).font(.subheadline.weight(.semibold))
                                Spacer()
                                Text(contributor.value).font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
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
            Image(systemName: icon).foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(message).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct TrendsView: View {
    let dashboardState: DashboardState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TrendChart(title: L10n.string("HRV"), unit: L10n.string("ms"), color: .teal, points: dashboardState.history.compactMap { summary in summary.hrvMilliseconds.map { TrendPoint(date: summary.date, value: $0) } })
                    TrendChart(title: L10n.string("Resting heart rate"), unit: L10n.string("bpm"), color: .pink, points: dashboardState.history.compactMap { summary in summary.restingHeartRate.map { TrendPoint(date: summary.date, value: $0) } })
                    TrendChart(title: L10n.string("Sleep"), unit: L10n.string("hours"), color: .indigo, points: dashboardState.history.compactMap { summary in summary.sleepHours.map { TrendPoint(date: summary.date, value: $0) } })
                    Text(L10n.string("Trends compare available Apple Health samples over time. Missing points usually mean no readable data was available for that day."))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L10n.string("Trends"))
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
                Text(title).font(.headline)
                Spacer()
                Text(latestValue).font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
            }
            if points.isEmpty {
                Text(L10n.string("No readable data yet"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                Chart(points) { point in
                    LineMark(x: .value(L10n.string("Date"), point.date), y: .value(title, point.value))
                        .foregroundStyle(color)
                        .interpolationMethod(.catmullRom)
                    AreaMark(x: .value(L10n.string("Date"), point.date), y: .value(title, point.value))
                        .foregroundStyle(color.opacity(0.12))
                        .interpolationMethod(.catmullRom)
                }
                .chartXAxis { AxisMarks(values: .automatic(desiredCount: 4)) }
                .chartYAxis { AxisMarks(position: .leading) }
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

struct PrivacySettingsView: View {
    let permissionState: HealthPermissionState
    let onRequestAccess: () async -> Void
    let onResetOnboarding: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.string("Privacy")) {
                    SettingsRow(icon: "iphone", title: L10n.string("On-device only"), detail: L10n.string("Health data is read locally on this iPhone."))
                    SettingsRow(icon: "icloud.slash", title: L10n.string("No cloud backend"), detail: L10n.string("Nervio does not use accounts, Firebase, Supabase, analytics SDKs, or external API calls."))
                    SettingsRow(icon: "square.and.pencil", title: L10n.string("Read-only"), detail: L10n.string("Nervio does not write data to Apple Health."))
                }
                Section(L10n.string("Apple Health")) {
                    HStack {
                        Label(L10n.string("Permission"), systemImage: "heart.text.square")
                        Spacer()
                        Text(permissionLabel).foregroundStyle(.secondary)
                    }
                    Button { Task { await onRequestAccess() } } label: { Label(L10n.string("Request Health Access"), systemImage: "heart.fill") }
                }
                Section(L10n.string("Onboarding")) {
                    Button(L10n.string("Show Onboarding Again"), action: onResetOnboarding)
                }
                Section {
                    Text(L10n.string("Nervio estimates wellness-oriented recovery signals from available Apple Health data. It does not diagnose stress, burnout, illness, or any medical condition."))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(L10n.string("Privacy"))
        }
    }

    private var permissionLabel: String {
        switch permissionState {
        case .notDetermined: L10n.string("Not requested")
        case .unavailable: L10n.string("Unavailable")
        case .requesting: L10n.string("Requesting")
        case .authorized: L10n.string("Requested")
        case .denied: L10n.string("Needs review")
        }
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(.teal).frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                Text(detail).font(.footnote).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private extension Double {
    var formattedHours: String { "\(String(format: "%.1f", self)) h" }
    var formattedMinutes: String { "\(Int(rounded())) min" }
}

#Preview {
    ContentView()
}
