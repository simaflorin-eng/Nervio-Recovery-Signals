import Charts
import HealthKit
import Observation
import SwiftUI
import WatchConnectivity
import WidgetKit

enum L10n {
    static func string(_ key: String) -> String {
        string(key, languageCode: selectedLanguageCode)
    }

    static func string(_ key: String, languageCode: String) -> String {
        if languageCode == AppLanguage.en.rawValue {
            return key
        }

        if let value = resourceTranslation(for: key, languageCode: languageCode) {
            return value
        }

        if let value = inAppTranslation(for: key, languageCode: languageCode) {
            return value
        }

        if let bundle = selectedLanguageBundle(languageCode: languageCode) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }

        return String(localized: String.LocalizationValue(key))
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: string(key), locale: selectedLocale, arguments: arguments)
    }

    private static var selectedLanguageCode: String {
        UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? AppLanguage.system.rawValue
    }

    private static var selectedLocale: Locale {
        let code = selectedLanguageCode
        return code == AppLanguage.system.rawValue ? .current : Locale(identifier: code)
    }

    private static func selectedLanguageBundle(languageCode: String) -> Bundle? {
        guard languageCode != AppLanguage.system.rawValue,
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }

    private static func resourceTranslation(for key: String, languageCode: String) -> String? {
        guard languageCode != AppLanguage.system.rawValue, languageCode != AppLanguage.en.rawValue else {
            return nil
        }

        let candidatePaths = [
            Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: "\(languageCode).lproj"),
            Bundle.main.path(forResource: languageCode, ofType: nil, inDirectory: "Localizable.strings")
        ].compactMap { $0 }

        for path in candidatePaths {
            guard let table = NSDictionary(contentsOfFile: path) as? [String: String],
                  let value = table[key] else {
                continue
            }

            return value
        }

        return nil
    }

    private static func inAppTranslation(for key: String, languageCode: String) -> String? {
        guard languageCode != AppLanguage.system.rawValue else {
            return nil
        }

        return inAppTranslations[languageCode]?[key] ?? supplementalTranslations[languageCode]?[key]
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

    private static let supplementalTranslations: [String: [String: String]] = [
        "ro": [
            "Nervio": "Nervio",
            "Recovery signal": "Semnal de recuperare",
            "Unavailable": "Indisponibil",
            "Supportive": "Favorabil",
            "Neutral": "Neutru",
            "Load": "Încărcare",
            "HRV": "HRV",
            "ms": "ms",
            "bpm": "bpm",
            "hours": "ore",
            "Date": "Dată",
            "Recovery and nervous system insights based on available Apple Health data.": "Informații despre recuperare și sistemul nervos bazate pe datele Apple Health disponibile.",
            "Private by design": "Privat prin proiectare",
            "Your health data never leaves your iPhone.": "Datele tale de sănătate nu părăsesc niciodată iPhone-ul.",
            "Read-only Health access": "Acces doar pentru citire la Sănătate",
            "Nervio reads HRV, resting heart rate, sleep, activity, workouts, and mindful sessions.": "Nervio citește HRV, pulsul în repaus, somnul, activitatea, antrenamentele și sesiunile de mindfulness.",
            "Transparent signals": "Semnale transparente",
            "Scores compare today with your own recent baseline and avoid medical conclusions.": "Scorurile compară ziua de azi cu propria ta bază recentă și evită concluziile medicale.",
            "Loading": "Se încarcă",
            "Connect Apple Health": "Conectează Apple Health",
            "Use Preview Data": "Folosește date demonstrative",
            "Apple Health is unavailable on this device. Preview data is shown in Simulator.": "Apple Health nu este disponibil pe acest dispozitiv. În Simulator sunt afișate date demonstrative.",
            "Health access was not granted. %@": "Accesul la Sănătate nu a fost acordat. %@",
            "No Apple Health samples were returned for the selected period. Open the Health app and confirm this iPhone has data for HRV, resting heart rate, sleep, steps, active energy, workouts, or mindful sessions.": "Nu au fost returnate mostre Apple Health pentru perioada selectată. Deschide aplicația Sănătate și confirmă că acest iPhone are date pentru HRV, puls în repaus, somn, pași, energie activă, antrenamente sau sesiuni de mindfulness.",
            "Apple Health access is connected, but no readable samples were returned yet. Check that individual Health permissions are enabled and that this device has recent Health data.": "Accesul la Apple Health este conectat, dar încă nu au fost returnate mostre lizibile. Verifică dacă permisiunile individuale din Sănătate sunt activate și dacă dispozitivul are date recente de sănătate.",
            "Nervio could not read Apple Health data. Check Health permissions and try again.": "Nervio nu a putut citi datele Apple Health. Verifică permisiunile din Sănătate și încearcă din nou.",
            "Missing NSHealthShareUsageDescription in the app target. Add the Health privacy usage description before requesting Apple Health access.": "Lipsește NSHealthShareUsageDescription din targetul aplicației. Adaugă descrierea de confidențialitate pentru Sănătate înainte de a solicita acces la Apple Health.",
            "Nervio needs at least a week of readable Apple Health history to form a personal baseline.": "Nervio are nevoie de cel puțin o săptămână de istoric Apple Health lizibil pentru a forma o bază personală.",
            "Nervio needs at least a week of readable Apple Health history to estimate physiological load.": "Nervio are nevoie de cel puțin o săptămână de istoric Apple Health lizibil pentru a estima încărcarea fiziologică.",
            "Nervio needs several days of Apple Health data before estimating a recovery signal.": "Nervio are nevoie de câteva zile de date Apple Health înainte de a estima un semnal de recuperare.",
            "Nervio needs several days of Apple Health data before estimating physiological load.": "Nervio are nevoie de câteva zile de date Apple Health înainte de a estima încărcarea fiziologică.",
            "Above your recent baseline, which may indicate stronger recovery signal.": "Peste baza ta recentă, ceea ce poate indica un semnal de recuperare mai puternic.",
            "Below your recent baseline, which may indicate higher physiological load.": "Sub baza ta recentă, ceea ce poate indica o încărcare fiziologică mai mare.",
            "Resting heart rate": "Puls în repaus",
            "Near or below baseline, supporting today’s recovery signal.": "Aproape de bază sau sub ea, susținând semnalul de recuperare de azi.",
            "Elevated versus baseline, which may indicate added load.": "Crescut față de bază, ceea ce poate indica încărcare suplimentară.",
            "Sleep duration and quality are supportive relative to your baseline.": "Durata și calitatea somnului sunt favorabile față de baza ta.",
            "Sleep appears lighter or shorter than your recent pattern.": "Somnul pare mai superficial sau mai scurt decât tiparul tău recent.",
            "Activity load is below or near baseline today.": "Încărcarea prin activitate este azi sub bază sau aproape de ea.",
            "Activity load is higher than baseline today.": "Încărcarea prin activitate este azi peste bază.",
            "Workouts": "Antrenamente",
            "Workout duration is not above your recent average.": "Durata antrenamentelor nu este peste media ta recentă.",
            "Workout duration is above your recent average, adding physiological load.": "Durata antrenamentelor este peste media ta recentă, adăugând încărcare fiziologică.",
            "Mindful minutes": "Minute de mindfulness",
            "Mindful sessions may support down-regulation and recovery routines.": "Sesiunile de mindfulness pot susține reglarea și rutinele de recuperare.",
            "Available Apple Health data suggests a stronger recovery signal today.": "Datele Apple Health disponibile sugerează azi un semnal de recuperare mai puternic.",
            "Available Apple Health data suggests a steady recovery signal today.": "Datele Apple Health disponibile sugerează azi un semnal de recuperare stabil.",
            "Available Apple Health data suggests some added physiological load today.": "Datele Apple Health disponibile sugerează azi o încărcare fiziologică suplimentară.",
            "Available Apple Health data suggests elevated physiological load today.": "Datele Apple Health disponibile sugerează azi o încărcare fiziologică ridicată.",
            "Available data suggests physiological load may be elevated today.": "Datele disponibile sugerează că încărcarea fiziologică poate fi ridicată azi.",
            "Available data suggests a moderate physiological load signal today.": "Datele disponibile sugerează azi un semnal moderat de încărcare fiziologică.",
            "Available data suggests a lower physiological load signal today.": "Datele disponibile sugerează azi un semnal mai scăzut de încărcare fiziologică.",
            "Available data suggests a very low physiological load signal today.": "Datele disponibile sugerează azi un semnal foarte scăzut de încărcare fiziologică.",
            "Based on %d baseline days. This is a wellness signal, not a diagnosis or medical conclusion.": "Bazat pe %d zile de referință. Acesta este un semnal de wellness, nu un diagnostic sau o concluzie medicală.",
            "Higher means available data may indicate more physiological load.": "Un scor mai mare înseamnă că datele disponibile pot indica o încărcare fiziologică mai mare.",
            "Contributors will appear after Nervio can compare today with your rolling baseline.": "Contribuitorii vor apărea după ce Nervio poate compara ziua de azi cu baza ta mobilă.",
            "No readable data yet": "Încă nu există date lizibile",
            "Trends compare available Apple Health samples over time. Missing points usually mean no readable data was available for that day.": "Tendințele compară în timp mostrele Apple Health disponibile. Punctele lipsă înseamnă de obicei că nu au existat date lizibile pentru ziua respectivă.",
            "On-device only": "Doar pe dispozitiv",
            "Health data is read locally on this iPhone.": "Datele de sănătate sunt citite local pe acest iPhone.",
            "No cloud backend": "Fără backend în cloud",
            "Nervio does not use accounts, Firebase, Supabase, analytics SDKs, or external API calls.": "Nervio nu folosește conturi, Firebase, Supabase, SDK-uri de analytics sau apeluri API externe.",
            "Read-only": "Doar citire",
            "Nervio does not write data to Apple Health.": "Nervio nu scrie date în Apple Health.",
            "Nervio estimates wellness-oriented recovery signals from available Apple Health data. It does not diagnose stress, burnout, illness, or any medical condition.": "Nervio estimează semnale de recuperare orientate spre wellness din datele Apple Health disponibile. Nu diagnostichează stres, epuizare, boală sau vreo afecțiune medicală."
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

private enum NervioVisuals {
    static let cornerRadius: CGFloat = 8
    static let horizontalPadding: CGFloat = 20
}

private struct NervioBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color(red: 0.03, green: 0.05, blue: 0.08), Color(red: 0.07, green: 0.09, blue: 0.12), Color(red: 0.02, green: 0.10, blue: 0.10)]
                    : [Color(red: 0.93, green: 0.98, blue: 0.98), Color(red: 0.98, green: 0.97, blue: 0.94), Color(red: 0.94, green: 0.96, blue: 1.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .teal.opacity(colorScheme == .dark ? 0.20 : 0.14),
                    .clear,
                    .pink.opacity(colorScheme == .dark ? 0.12 : 0.09)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

private struct NervioCardBackground: View {
    let tint: Color

    var body: some View {
        RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous)
            .fill(.thinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.45), tint.opacity(0.22), Color.primary.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: tint.opacity(0.12), radius: 16, x: 0, y: 10)
    }
}

private extension View {
    func nervioCard(tint: Color = .teal, padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background {
                NervioCardBackground(tint: tint)
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
        .onChange(of: selectedLanguageCode) {
            appModel.relocalizeDashboard()
        }
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
    var dashboardState: DashboardState = .mock {
        didSet {
            publishWidgetSnapshot()
        }
    }
    var isLoading = false
    var errorMessage: String?

    private let baselineCalculator = BaselineCalculator()
    private let scoreEngine = RecoveryScoreEngine()
    private let watchTransfer = NervioWatchTransfer.shared

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

    func relocalizeDashboard() {
        let currentState = dashboardState

        if let today = currentState.today, !currentState.history.isEmpty {
            let baselineResult = baselineCalculator.baseline(from: currentState.history, before: today.date)
            let baseline = currentState.baseline.availableMetricCount > 0 ? currentState.baseline : baselineResult.baseline
            let baselineDays = baselineResult.days
            dashboardState = DashboardState(
                today: today,
                baseline: baseline,
                score: scoreEngine.score(today: today, baseline: baseline, baselineDays: baselineDays),
                stressScore: scoreEngine.stressScore(today: today, baseline: baseline, baselineDays: baselineDays),
                history: currentState.history
            )
        } else {
            dashboardState = DashboardState(
                today: currentState.today,
                baseline: currentState.baseline,
                score: .insufficientData,
                stressScore: .insufficientData,
                history: currentState.history
            )
        }

        errorMessage = relocalizedErrorMessage(errorMessage)
    }

    private func publishWidgetSnapshot() {
        let snapshot = NervioWidgetSnapshot(dashboardState: dashboardState)
        NervioWidgetSnapshotStore.save(snapshot)
        watchTransfer.send(snapshot)
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_recovery_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_stress_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_signal_widget_v2")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_signal_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_widget")
    }

    private func relocalizedErrorMessage(_ message: String?) -> String? {
        guard let message else { return nil }

        let knownMessages = [
            "No Apple Health samples were returned for the selected period. Open the Health app and confirm this iPhone has data for HRV, resting heart rate, sleep, steps, active energy, workouts, or mindful sessions.",
            "Apple Health access is connected, but no readable samples were returned yet. Check that individual Health permissions are enabled and that this device has recent Health data.",
            "Nervio could not read Apple Health data. Check Health permissions and try again."
        ]

        return knownMessages
            .first { key in
                AppLanguage.allCases.contains { language in
                    L10n.string(key, languageCode: language.rawValue) == message || key == message
                }
            }
            .map { L10n.string($0) } ?? message
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
        async let stepSamples = safeAppleWatchStepSamples(startDate: startDate, endDate: endDate)
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

    private func appleWatchStepSamples(startDate: Date, endDate: Date) async throws -> [HKQuantitySample] {
        try await quantitySamples(identifier: .stepCount, startDate: startDate, endDate: endDate)
            .filter { isAppleWatchStepSample($0) }
    }

    private func safeAppleWatchStepSamples(startDate: Date, endDate: Date) async -> [HKQuantitySample] {
        do {
            return try await appleWatchStepSamples(startDate: startDate, endDate: endDate)
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
    private let activityLoadCalculator = ActivityLoadCalculator()

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

        if let activityLoad = activityLoadCalculator.result(today: today, baseline: baseline) {
            let reducedRecovery = hasReducedRecoverySignals(today: today, baseline: baseline)
            let impact = activityLoad.recoveryImpact(whenCombinedWithReducedRecoverySignals: reducedRecovery)
            contributors.append(.init(
                title: L10n.string("Activity Load"),
                value: activityLoad.label,
                detail: activityLoad.explanation(hasReducedRecoverySignals: reducedRecovery),
                impact: impact,
                direction: direction(for: impact)
            ))
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

        if let activityLoad = activityLoadCalculator.result(today: today, baseline: baseline),
           hasReducedRecoverySignals(today: today, baseline: baseline) {
            load += activityLoad.physiologicalLoadImpact
        }

        return load
    }

    private func hasReducedRecoverySignals(today: DailyHealthSummary, baseline: HealthBaseline) -> Bool {
        let lowHRV = today.hrvMilliseconds.flatMap { hrv in
            baseline.hrvMilliseconds.map { baselineHRV in baselineHRV > 0 && hrv < baselineHRV * 0.95 }
        } ?? false

        let elevatedRestingHeartRate = today.restingHeartRate.flatMap { rhr in
            baseline.restingHeartRate.map { baselineRHR in baselineRHR > 0 && rhr > baselineRHR * 1.05 }
        } ?? false

        let poorSleep = today.sleepHours.flatMap { sleep in
            baseline.sleepHours.map { baselineSleep in baselineSleep > 0 && sleep < baselineSleep * 0.92 }
        } ?? false || (today.sleepEfficiency ?? 1) < 0.78

        return lowHRV || elevatedRestingHeartRate || poorSleep
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

struct ActivityLoadResult: Hashable {
    enum Level: String {
        case low = "Low"
        case normal = "Normal"
        case elevated = "Elevated"
        case high = "High"
    }

    let todaySteps: Double
    let average7DaySteps: Double?
    let average21DaySteps: Double
    let ratio: Double
    let level: Level

    var label: String {
        L10n.string(level.rawValue)
    }

    var percentVersusUsual: Int {
        Int(((ratio - 1) * 100).rounded())
    }

    var stepsVersusBaselineText: String {
        if percentVersusUsual == 0 {
            return L10n.string("Within your usual level")
        }

        let sign = percentVersusUsual > 0 ? "+" : ""
        return L10n.format("%@%d%% vs your usual level", sign, percentVersusUsual)
    }

    var physiologicalLoadImpact: Int {
        switch level {
        case .low, .normal: 0
        case .elevated: 6
        case .high: 10
        }
    }

    func recoveryImpact(whenCombinedWithReducedRecoverySignals reducedRecoverySignals: Bool) -> Int {
        guard reducedRecoverySignals else { return 0 }

        switch level {
        case .low, .normal: return 0
        case .elevated: return -5
        case .high: return -8
        }
    }

    func explanation(hasReducedRecoverySignals: Bool) -> String {
        switch level {
        case .low:
            return L10n.string("Activity load was lower than usual.")
        case .normal:
            return L10n.string("Your movement level is within your normal range.")
        case .elevated:
            return hasReducedRecoverySignals
                ? L10n.string("Higher recent activity combined with reduced recovery signals may indicate accumulated physiological load.")
                : L10n.string("Activity load was higher than usual, without reduced recovery signals.")
        case .high:
            return hasReducedRecoverySignals
                ? L10n.string("High recent activity combined with reduced recovery signals may indicate accumulated fatigue.")
                : L10n.string("Activity load was much higher than usual, but is not reducing recovery by itself.")
        }
    }
}

struct ActivityLoadCalculator {
    func result(today: DailyHealthSummary?, baseline: HealthBaseline) -> ActivityLoadResult? {
        guard let today,
              let todaySteps = today.stepCount,
              let average21DaySteps = baseline.stepCount,
              average21DaySteps > 0 else {
            return nil
        }

        return result(todaySteps: todaySteps, average7DaySteps: nil, average21DaySteps: average21DaySteps)
    }

    func result(from summaries: [DailyHealthSummary]) -> ActivityLoadResult? {
        guard let today = summaries.last,
              let todaySteps = today.stepCount else {
            return nil
        }

        let previousDays = Array(summaries.dropLast().reversed())
        let average7DaySteps = average(previousDays.prefix(7).compactMap(\.stepCount))
        guard let average21DaySteps = average(previousDays.prefix(21).compactMap(\.stepCount)),
              average21DaySteps > 0 else {
            return nil
        }

        return result(todaySteps: todaySteps, average7DaySteps: average7DaySteps, average21DaySteps: average21DaySteps)
    }

    private func result(todaySteps: Double, average7DaySteps: Double?, average21DaySteps: Double) -> ActivityLoadResult {
        let ratio = todaySteps / average21DaySteps
        let level: ActivityLoadResult.Level

        switch ratio {
        case ..<0.5:
            level = .low
        case 0.5..<1.3:
            level = .normal
        case 1.3...1.7:
            level = .elevated
        default:
            level = .high
        }

        return ActivityLoadResult(
            todaySteps: todaySteps,
            average7DaySteps: average7DaySteps,
            average21DaySteps: average21DaySteps,
            ratio: ratio,
            level: level
        )
    }

    private func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
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

    static var insufficientData: RecoveryScore {
        RecoveryScore(value: nil, status: .insufficientData, summary: L10n.string("Nervio needs several days of Apple Health data before estimating a recovery signal."), contributors: [], baselineDays: 0)
    }
}

struct StressScore: Hashable {
    let value: Int?
    let summary: String
    let baselineDays: Int

    static var insufficientData: StressScore {
        StressScore(value: nil, summary: L10n.string("Nervio needs several days of Apple Health data before estimating physiological load."), baselineDays: 0)
    }
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

    static var mock: DashboardState {
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
    }
}

private extension NervioWidgetSnapshot {
    init(dashboardState: DashboardState) {
        let today = dashboardState.today
        self.init(
            recoveryValue: dashboardState.score.value,
            stressValue: dashboardState.stressScore.value,
            status: dashboardState.score.status.localizedTitle,
            summary: dashboardState.score.summary,
            baselineDays: dashboardState.score.baselineDays,
            hrv: NervioWidgetMetric(
                title: L10n.string("HRV"),
                value: today?.hrvMilliseconds.map { "\(Int($0.rounded())) ms" } ?? "--",
                symbolName: "waveform.path.ecg"
            ),
            restingHeartRate: NervioWidgetMetric(
                title: L10n.string("Resting HR"),
                value: today?.restingHeartRate.map { "\(Int($0.rounded())) bpm" } ?? "--",
                symbolName: "heart"
            ),
            sleep: NervioWidgetMetric(
                title: L10n.string("Sleep"),
                value: today?.sleepHours.map { String(format: "%.1f h", $0) } ?? "--",
                symbolName: "bed.double"
            ),
            steps: NervioWidgetMetric(
                title: L10n.string("Apple Watch Steps"),
                value: today?.stepCount.map { Self.stepsFormatter.string(from: NSNumber(value: Int($0.rounded()))) ?? "\(Int($0.rounded()))" } ?? "--",
                symbolName: "figure.walk"
            ),
            stepsValue: today?.stepCount.map { Int($0.rounded()) },
            updatedAt: .now
        )
    }

    private static let stepsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

private final class NervioWatchTransfer: NSObject, WCSessionDelegate {
    static let shared = NervioWatchTransfer()

    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    private override init() {
        super.init()
        guard let session else { return }
        session.delegate = self
        if session.activationState == .notActivated {
            session.activate()
        }
    }

    func send(_ snapshot: NervioWidgetSnapshot) {
        guard let session,
              session.activationState == .activated,
              session.isPaired,
              session.isWatchAppInstalled,
              let data = try? JSONEncoder().encode(snapshot) else {
            return
        }

        try? session.updateApplicationContext(["nervio.widget.snapshot": data])
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func sessionDidBecomeInactive(_ session: WCSession) { }

    func sessionDidDeactivate(_ session: WCSession) {
        if session.activationState == .notActivated {
            session.activate()
        }
    }
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
            ZStack {
                NervioBackground()

                VStack(alignment: .leading, spacing: 24) {
                    Spacer(minLength: 20)

                    VStack(alignment: .leading, spacing: 18) {
                        ZStack {
                            RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous)
                                .fill(.teal.gradient)
                                .frame(width: 72, height: 72)
                                .shadow(color: .teal.opacity(0.24), radius: 18, y: 10)

                            Image(systemName: "waveform.path.ecg.rectangle")
                                .font(.system(size: 34, weight: .semibold))
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(L10n.string("Nervio"))
                                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            Text(L10n.string("Recovery and nervous system insights based on available Apple Health data."))
                                .font(.title3.weight(.medium))
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    VStack(spacing: 12) {
                        OnboardingPoint(icon: "lock.shield", title: L10n.string("Private by design"), detail: L10n.string("Your health data never leaves your iPhone."))
                        OnboardingPoint(icon: "heart.text.square", title: L10n.string("Read-only Health access"), detail: L10n.string("Nervio reads HRV, resting heart rate, sleep, activity, workouts, and mindful sessions."))
                        OnboardingPoint(icon: "chart.line.uptrend.xyaxis", title: L10n.string("Transparent signals"), detail: L10n.string("Scores compare today with your own recent baseline and avoid medical conclusions."))
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    VStack(spacing: 12) {
                        Button {
                            Task { await onContinue() }
                        } label: {
                            Label(isLoading ? L10n.string("Loading") : L10n.string("Connect Apple Health"), systemImage: "heart.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.teal)
                        .controlSize(.large)
                        .disabled(isLoading || permissionState == .requesting)

                        Button(L10n.string("Use Preview Data"), action: onUsePreviewData)
                            .buttonStyle(.borderless)
                            .font(.subheadline.weight(.semibold))
                        permissionMessage
                    }
                }
                .padding(24)
            }
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
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(.teal.gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
        .nervioCard(tint: .teal, padding: 14)
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
            ZStack {
                NervioBackground()

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
                .scrollContentBackground(.hidden)
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
            ZStack {
                NervioBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        ScoreHeader(score: dashboardState.score)
                        StressScoreCard(stressScore: dashboardState.stressScore)
                        if let errorMessage {
                            MessageBanner(icon: "exclamationmark.triangle", title: L10n.string("Health data status"), message: errorMessage)
                        } else if dashboardState.score.status == .insufficientData {
                            MessageBanner(icon: "calendar.badge.clock", title: L10n.string("More data needed"), message: dashboardState.score.summary)
                        }
                        TodayMetricsView(dashboardState: dashboardState)
                        ContributorsView(contributors: dashboardState.score.contributors)
                    }
                    .padding(.horizontal, NervioVisuals.horizontalPadding)
                    .padding(.vertical, 16)
                }
            }
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(score.status.localizedTitle)
                        .font(.caption.weight(.bold))
                        .textCase(.uppercase)
                        .foregroundStyle(.teal)
                    Text(score.summary)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 4)
                ZStack {
                    Circle().fill(.ultraThinMaterial)
                    Circle().stroke(.white.opacity(0.38), lineWidth: 1)
                    Circle().stroke(recoveryTint.opacity(0.16), lineWidth: 12)
                    Circle()
                        .trim(from: 0, to: CGFloat(score.value ?? 0) / 100)
                        .stroke(
                            LinearGradient(colors: recoveryGradientColors, startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
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
        .nervioCard(tint: recoveryTint, padding: 18)
    }

    private var recoveryTint: Color {
        semanticRecoveryColors(for: score.value).first ?? .teal
    }

    private var recoveryGradientColors: [Color] {
        semanticRecoveryColors(for: score.value)
    }
}

private struct StressScoreCard: View {
    let stressScore: StressScore

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle().fill(.ultraThinMaterial)
                Circle().stroke(stressTint.opacity(0.16), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(stressScore.value ?? 0) / 100)
                    .stroke(
                        LinearGradient(colors: stressGradientColors, startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
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
        .nervioCard(tint: stressTint, padding: 16)
    }

    private var stressTint: Color {
        semanticStressColors(for: stressScore.value).first ?? .orange
    }

    private var stressGradientColors: [Color] {
        semanticStressColors(for: stressScore.value)
    }
}

private func semanticRecoveryColors(for value: Int?) -> [Color] {
    guard let value else { return [.teal, .mint] }

    switch value {
    case 80...100:
        return [.green, .mint]
    case 60..<80:
        return [.yellow, .green]
    case 40..<60:
        return [.orange, .yellow]
    default:
        return [.red, .orange]
    }
}

private func semanticStressColors(for value: Int?) -> [Color] {
    guard let value else { return [.orange, .yellow] }

    switch value {
    case 75...100:
        return [.red, .orange]
    case 50..<75:
        return [.orange, .yellow]
    case 25..<50:
        return [.yellow, .green]
    default:
        return [.green, .mint]
    }
}

private struct TodayMetricsView: View {
    let dashboardState: DashboardState

    private var summary: DailyHealthSummary? {
        dashboardState.today
    }

    private var activityLoad: ActivityLoadResult? {
        ActivityLoadCalculator().result(from: dashboardState.history)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.string("Today’s inputs")).font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricTile(title: L10n.string("HRV"), value: summary?.hrvMilliseconds.map { "\(Int($0.rounded())) ms" } ?? "--", icon: "waveform.path.ecg", tint: .teal)
                MetricTile(title: L10n.string("Resting HR"), value: summary?.restingHeartRate.map { "\(Int($0.rounded())) bpm" } ?? "--", icon: "heart", tint: .pink)
                MetricTile(title: L10n.string("Sleep"), value: summary?.sleepHours.map { String(format: "%.1f h", $0) } ?? "--", icon: "bed.double", tint: .indigo)
                MetricTile(title: L10n.string("Apple Watch Steps"), value: summary?.stepCount.map { Self.stepsFormatter.string(from: NSNumber(value: Int($0.rounded()))) ?? "\(Int($0.rounded()))" } ?? "--", icon: "figure.walk", tint: .green)
            }

            ActivityLoadCard(activityLoad: activityLoad)
        }
    }

    private static let stepsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

private struct ActivityLoadCard: View {
    let activityLoad: ActivityLoadResult?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "figure.walk.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(tint.gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(L10n.string("Activity Load"))
                        .font(.subheadline.weight(.semibold))
                    Text(activityLoad?.label ?? L10n.string("No Apple Watch step data available."))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }

            if let activityLoad {
                Text(activityLoad.stepsVersusBaselineText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tint)
                Text(L10n.format("7-day average: %@ steps • 21-day average: %@ steps", formattedSteps(activityLoad.average7DaySteps), formattedSteps(activityLoad.average21DaySteps)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nervioCard(tint: tint, padding: 14)
    }

    private var tint: Color {
        switch activityLoad?.level {
        case .low: .teal
        case .normal: .green
        case .elevated: .orange
        case .high: .red
        case nil: .secondary
        }
    }

    private func formattedSteps(_ value: Double?) -> String {
        guard let value else { return "--" }
        return Self.stepsFormatter.string(from: NSNumber(value: Int(value.rounded()))) ?? "\(Int(value.rounded()))"
    }

    private static let stepsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

private struct MetricTile: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
            Text(value).font(.title3.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.75)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nervioCard(tint: tint, padding: 14)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .nervioCard(tint: .teal, padding: 16)
            } else {
                ForEach(contributors) { contributor in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: icon(for: contributor.direction))
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(color(for: contributor.direction).gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
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
                    .nervioCard(tint: color(for: contributor.direction), padding: 14)
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
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(.orange.gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(message).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .nervioCard(tint: .orange, padding: 14)
    }
}

struct TrendsView: View {
    let dashboardState: DashboardState

    var body: some View {
        NavigationStack {
            ZStack {
                NervioBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        TrendChart(title: L10n.string("HRV"), unit: L10n.string("ms"), color: .teal, points: dashboardState.history.compactMap { summary in summary.hrvMilliseconds.map { TrendPoint(date: summary.date, value: $0) } })
                        TrendChart(title: L10n.string("Resting heart rate"), unit: L10n.string("bpm"), color: .pink, points: dashboardState.history.compactMap { summary in summary.restingHeartRate.map { TrendPoint(date: summary.date, value: $0) } })
                        TrendChart(title: L10n.string("Sleep"), unit: L10n.string("hours"), color: .indigo, points: dashboardState.history.compactMap { summary in summary.sleepHours.map { TrendPoint(date: summary.date, value: $0) } })
                        TrendChart(title: L10n.string("Apple Watch Steps"), unit: L10n.string("steps"), color: .green, points: dashboardState.history.compactMap { summary in summary.stepCount.map { TrendPoint(date: summary.date, value: $0) } })
                        Text(L10n.string("Trends compare available Apple Health samples over time. Missing points usually mean no readable data was available for that day."))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .nervioCard(tint: .indigo, padding: 14)
                    }
                    .padding(.horizontal, NervioVisuals.horizontalPadding)
                    .padding(.vertical, 16)
                }
            }
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
                Text(title).font(.headline.weight(.semibold))
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
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                    AreaMark(x: .value(L10n.string("Date"), point.date), y: .value(title, point.value))
                        .foregroundStyle(
                            LinearGradient(colors: [color.opacity(0.26), color.opacity(0.03)], startPoint: .top, endPoint: .bottom)
                        )
                        .interpolationMethod(.catmullRom)
                }
                .chartXAxis { AxisMarks(values: .automatic(desiredCount: 4)) }
                .chartYAxis { AxisMarks(position: .leading) }
                .frame(height: 180)
            }
        }
        .nervioCard(tint: color, padding: 16)
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
            ZStack {
                NervioBackground()

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
                .scrollContentBackground(.hidden)
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
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(.teal.gradient, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
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
