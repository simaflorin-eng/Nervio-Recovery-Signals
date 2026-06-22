import Charts
import FoundationModels
import HealthKit
import Observation
import SwiftUI
import UserNotifications
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
            "Needs review": "Necesită verificare",
            "Compare": "Compară",
            "Month": "Lună",
            "Year": "An",
            "This month vs same month last year": "Luna aceasta vs aceeași lună anul trecut",
            "This year vs last year": "Anul acesta vs anul trecut",
            "Not enough historical data yet for year-over-year comparison.": "Nu există încă suficiente date istorice pentru comparația anuală.",
            "This month": "Luna aceasta",
            "This year": "Anul acesta",
            "Same month last year": "Aceeași lună anul trecut",
            "Last year": "Anul trecut",
            "Support": "Suport",
            "Leave a Review": "Lasă un review"
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
            "Needs review": "À vérifier",
            "Support": "Support",
            "Leave a Review": "Laisser un avis"
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
            "Needs review": "Überprüfung nötig",
            "Support": "Support",
            "Leave a Review": "Bewertung abgeben"
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
            "Needs review": "Requiere revisión",
            "Support": "Soporte",
            "Leave a Review": "Dejar una reseña"
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
            "Needs review": "Da verificare",
            "Support": "Supporto",
            "Leave a Review": "Lascia una recensione"
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
            "Needs review": "Precisa de revisão",
            "Support": "Suporte",
            "Leave a Review": "Deixar uma avaliação"
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
    static let cornerRadius: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
}

struct NervioBackground: View {
    var tint: Color = .teal
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
                    tint.opacity(colorScheme == .dark ? 0.22 : 0.16),
                    .clear,
                    .pink.opacity(colorScheme == .dark ? 0.12 : 0.09)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.8), value: tint)
        }
    }
}

private struct NervioCardBackground: View {
    let tint: Color

    var body: some View {
        RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous)
            .fill(.regularMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
            }
    }
}

private extension View {
    @ViewBuilder
    func nervioCard(tint: Color = .teal, padding: CGFloat = 16) -> some View {
        if #available(iOS 26.0, *) {
            self
                .padding(padding)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: NervioVisuals.cornerRadius, style: .continuous))
        } else {
            self
                .padding(padding)
                .background { NervioCardBackground(tint: tint) }
        }
    }
}

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedLanguageCode") private var selectedLanguageCode = AppLanguage.system.rawValue
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    @AppStorage("reviewLaunchCount") private var reviewLaunchCount = 0
    @AppStorage("hasAcceptedReviewPrompt") private var hasAcceptedReviewPrompt = false
    @State private var healthKitManager = HealthKitManager()
    @State private var appModel = NervioAppModel()
    @State private var showReviewPrompt = false
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

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
            persistWidgetLanguageSelection()
            appModel.relocalizeDashboard()
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .active, hasCompletedOnboarding else { return }
            Task { await refreshDashboard() }
        }
        .alert(reviewPromptTitleText, isPresented: $showReviewPrompt) {
            Button(reviewPromptDeclineButtonText, role: .cancel) {}
            Button(reviewPromptAcceptButtonText) {
                hasAcceptedReviewPrompt = true
                openAppStoreReview()
            }
        } message: {
            Text(reviewPromptMessageText)
        }
        .task {
            handleReviewPromptIfNeeded()
            persistWidgetLanguageSelection()
            guard hasCompletedOnboarding else { return }
            await refreshDashboard()
        }
    }

    private func persistWidgetLanguageSelection() {
        let appGroupIdentifier = "group.com.florinsima.Nervio-Recovery-Signals"
        let key = "selectedLanguageCode"
        (UserDefaults(suiteName: appGroupIdentifier) ?? .standard).set(selectedLanguageCode, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_recovery_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_stress_widget")
    }

    private func completeOnboardingWithHealthAccess() async {
        await healthKitManager.requestReadAuthorization()
        await refreshDashboard()
        hasCompletedOnboarding = true
    }

    private func refreshDashboard() async {
        await appModel.loadDashboard(using: healthKitManager)
    }

    private func handleReviewPromptIfNeeded() {
        guard !hasAcceptedReviewPrompt else { return }

        reviewLaunchCount += 1
        if reviewLaunchCount.isMultiple(of: 8) {
            showReviewPrompt = true
        }
    }

    private func openAppStoreReview() {
        guard let reviewURL = AppStoreReviewLink.writeReviewURL else { return }
        openURL(reviewURL)
    }

    private var reviewPromptTitleText: String {
        switch selectedLanguageCode {
        case AppLanguage.ro.rawValue: "Îți place aplicația Nervio?"
        case AppLanguage.fr.rawValue: "Vous aimez l’app Nervio ?"
        case AppLanguage.de.rawValue: "Gefällt dir die Nervio-App?"
        case AppLanguage.es.rawValue: "¿Te gusta la app Nervio?"
        case AppLanguage.it.rawValue: "Ti piace l’app Nervio?"
        case AppLanguage.pt.rawValue: "Gostas da app Nervio?"
        default: "Do you like the Nervio app?"
        }
    }

    private var reviewPromptMessageText: String {
        switch selectedLanguageCode {
        case AppLanguage.ro.rawValue: "Ne-ar ajuta mult un review în App Store."
        case AppLanguage.fr.rawValue: "Un avis sur l’App Store nous aiderait beaucoup."
        case AppLanguage.de.rawValue: "Eine Bewertung im App Store würde uns sehr helfen."
        case AppLanguage.es.rawValue: "Una reseña en App Store nos ayudaría mucho."
        case AppLanguage.it.rawValue: "Una recensione sull’App Store ci aiuterebbe molto."
        case AppLanguage.pt.rawValue: "Uma avaliação na App Store ajudar-nos-ia muito."
        default: "A review on the App Store would help us a lot."
        }
    }

    private var reviewPromptAcceptButtonText: String {
        switch selectedLanguageCode {
        case AppLanguage.ro.rawValue: "Da, las review"
        case AppLanguage.fr.rawValue: "Oui, laisser un avis"
        case AppLanguage.de.rawValue: "Ja, Bewertung abgeben"
        case AppLanguage.es.rawValue: "Sí, dejar reseña"
        case AppLanguage.it.rawValue: "Sì, lascia una recensione"
        case AppLanguage.pt.rawValue: "Sim, deixar avaliação"
        default: "Yes, leave a review"
        }
    }

    private var reviewPromptDeclineButtonText: String {
        switch selectedLanguageCode {
        case AppLanguage.ro.rawValue: "Nu acum"
        case AppLanguage.fr.rawValue: "Pas maintenant"
        case AppLanguage.de.rawValue: "Jetzt nicht"
        case AppLanguage.es.rawValue: "Ahora no"
        case AppLanguage.it.rawValue: "Non ora"
        case AppLanguage.pt.rawValue: "Agora não"
        default: "Not now"
        }
    }
}

@MainActor
@Observable
final class NervioAppModel {
    var dashboardState: DashboardState = .mock {
        didSet { publishWidgetSnapshot() }
    }
    var isLoading = false
    var errorMessage: String?
    var aiInsight: String?
    var isAIInsight = false
    var isGeneratingInsight = false
    private var aiUnavailable = false

    private let baselineCalculator = BaselineCalculator()
    private let scoreEngine = RecoveryScoreEngine()
    private let watchTransfer = NervioWatchTransfer.shared

    func loadDashboard(using healthKitManager: HealthKitManager) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let summaries = try await healthKitManager.fetchDailySummaries(days: 60)
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
            let scoreHistory: [DailyScorePoint] = summaries.suffix(42).map { summary in
                let r = baselineCalculator.baseline(from: summaries, before: summary.date)
                let s = scoreEngine.score(today: summary, baseline: r.baseline, baselineDays: r.days)
                return DailyScorePoint(date: summary.date, value: s.value)
            }
            dashboardState = DashboardState(today: today, baseline: baselineResult.baseline, score: score, stressScore: stressScore, history: summaries, scoreHistory: scoreHistory)
            NervioNotificationManager.shared.scheduleIfNeeded(score: score)
            Task { await generateInsight(for: dashboardState) }
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
        NervioProManager.shared.syncToAppGroup()
        let snapshot = NervioWidgetSnapshot(dashboardState: dashboardState)
        NervioWidgetSnapshotStore.save(snapshot)
        watchTransfer.send(snapshot)
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_recovery_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_stress_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_signal_widget_v2")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_signal_widget")
        WidgetCenter.shared.reloadTimelines(ofKind: "nervio_widget")
        if NervioProManager.shared.isPro,
           UserDefaults.standard.bool(forKey: "liveActivitiesEnabled") {
            NervioLiveActivityManager.shared.startOrUpdate(with: snapshot)
        }
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

    func generateInsight(for state: DashboardState) async {
        aiInsight = ruleBasedInsight(for: state)
        isAIInsight = false
        if #available(iOS 26.0, *), !aiUnavailable {
            await upgradedInsightIfAvailable(for: state)
        }
    }

    @available(iOS 26.0, *)
    private func upgradedInsightIfAvailable(for state: DashboardState) async {
        let model = SystemLanguageModel.default
        guard model.availability == .available else {
            aiUnavailable = true
            return
        }
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        do {
            var parts: [String] = []
            if let v = state.score.value { parts.append("recovery score \(v)/100") }
            if let v = state.stressScore.value { parts.append("physiological load \(v)/100") }
            if let hrv = state.today?.hrvMilliseconds { parts.append("HRV \(Int(hrv.rounded()))ms") }
            if let rhr = state.today?.restingHeartRate { parts.append("resting HR \(Int(rhr.rounded()))bpm") }
            if let sleep = state.today?.sleepHours { parts.append("sleep \(String(format: "%.1f", sleep))h") }
            let prompt = "You are a supportive wellness coach. Based on these health metrics — \(parts.joined(separator: ", ")) — write exactly 2 warm, encouraging sentences: first about what today's data suggests, second about appropriate activity intensity. No medical claims. Be specific and actionable."
            let session = LanguageModelSession()
            let response = try await session.respond(to: prompt)
            aiInsight = response.content
            isAIInsight = true
        } catch {
            aiUnavailable = true
        }
    }

    private func ruleBasedInsight(for state: DashboardState) -> String? {
        guard let value = state.score.value else { return nil }
        switch value {
        case 80...100:
            return "Your physiological markers point to a strong recovery state today. This is a good day for a demanding session or an athletic goal you have been working toward."
        case 60..<80:
            return "Your recovery looks balanced and your metrics are in a solid range. Moderate to normal training intensity is appropriate — listen to how your body responds."
        case 40..<60:
            return "Your metrics show some physiological load today. Keeping activity lighter and prioritizing good sleep tonight will help your recovery build back up."
        default:
            return "Your body's signals suggest elevated load. A rest day or gentle movement like a walk may be the most effective thing you do today."
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

    func fetchAppleWatchStepTotal(startDate: Date, endDate: Date) async -> Double? {
        guard isHealthDataAvailable else { return nil }
        let samples = await safeAppleWatchStepSamples(startDate: startDate, endDate: endDate)
        let total = samples.reduce(0.0) { partial, sample in
            partial + sample.quantity.doubleValue(for: .count())
        }
        return total > 0 ? total : nil
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
        var summaries = days(from: startDate, through: endDate).map { day in
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

        // If today's resting HR is missing, keep UI populated with the most recent
        // reading from the last 24h to avoid empty dashboard cards in the morning.
        if let todayIndex = summaries.indices.last, summaries[todayIndex].restingHeartRate == nil {
            let lookbackStart = calendar.date(byAdding: .day, value: -1, to: summaries[todayIndex].date) ?? summaries[todayIndex].date
            let candidateSamples = restingHeartRateSamples.filter { $0.startDate >= lookbackStart && $0.startDate <= endDate }
            if let latest = candidateSamples.max(by: { $0.startDate < $1.startDate }) {
                summaries[todayIndex] = DailyHealthSummary(
                    date: summaries[todayIndex].date,
                    hrvMilliseconds: summaries[todayIndex].hrvMilliseconds,
                    restingHeartRate: latest.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                    sleepHours: summaries[todayIndex].sleepHours,
                    sleepEfficiency: summaries[todayIndex].sleepEfficiency,
                    stepCount: summaries[todayIndex].stepCount,
                    activeEnergyKilocalories: summaries[todayIndex].activeEnergyKilocalories,
                    workoutMinutes: summaries[todayIndex].workoutMinutes,
                    mindfulMinutes: summaries[todayIndex].mindfulMinutes
                )
            }
        }

        return summaries
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

struct DailyScorePoint: Identifiable, Hashable {
    var id: Date { date }
    let date: Date
    let value: Int?
}

struct DashboardState: Hashable {
    let today: DailyHealthSummary?
    let baseline: HealthBaseline
    let score: RecoveryScore
    let stressScore: StressScore
    let history: [DailyHealthSummary]
    let scoreHistory: [DailyScorePoint]

    init(
        today: DailyHealthSummary?,
        baseline: HealthBaseline,
        score: RecoveryScore,
        stressScore: StressScore,
        history: [DailyHealthSummary],
        scoreHistory: [DailyScorePoint] = []
    ) {
        self.today = today
        self.baseline = baseline
        self.score = score
        self.stressScore = stressScore
        self.history = history
        self.scoreHistory = scoreHistory
    }

    static var mock: DashboardState {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let history = (0..<28).compactMap { offset -> DailyHealthSummary? in
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
        let baselineCalc = BaselineCalculator()
        let score = engine.score(today: history.last, baseline: baseline, baselineDays: 20)
        let stressScore = engine.stressScore(today: history.last, baseline: baseline, baselineDays: 20)
        let scoreHistory: [DailyScorePoint] = history.map { summary in
            let result = baselineCalc.baseline(from: history, before: summary.date)
            let s = engine.score(today: summary, baseline: result.baseline, baselineDays: result.days)
            return DailyScorePoint(date: summary.date, value: s.value)
        }
        return DashboardState(today: history.last, baseline: baseline, score: score, stressScore: stressScore, history: history, scoreHistory: scoreHistory)
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
                title: L10n.string("Steps"),
                value: today?.stepCount.map { Self.stepsFormatter.string(from: NSNumber(value: Int($0.rounded()))) ?? "\(Int($0.rounded()))" } ?? "--",
                symbolName: "figure.walk"
            ),
            stepsValue: today?.stepCount.map { Int($0.rounded()) },
            updatedAt: .now,
            languageCode: UserDefaults.standard.string(forKey: "selectedLanguageCode"),
            recoveryLabel: L10n.string("Recovery"),
            stressLabel: L10n.string("Stress"),
            stepsLabel: L10n.string("Steps")
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

@MainActor
final class NervioNotificationManager {
    static let shared = NervioNotificationManager()
    private init() {}

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "notificationsEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "notificationsEnabled") }
    }
    private var hour: Int {
        let h = UserDefaults.standard.integer(forKey: "notificationHour")
        return h == 0 && !UserDefaults.standard.contains("notificationHour") ? 8 : h
    }
    private var minute: Int { UserDefaults.standard.integer(forKey: "notificationMinute") }

    func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }

    func scheduleIfNeeded(score: RecoveryScore) {
        guard isEnabled, let value = score.value else { return }
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["nervio.morning"])
        let content = UNMutableNotificationContent()
        content.title = "Nervio"
        content.body = body(for: value)
        content.sound = .default
        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute
        let request = UNNotificationRequest(identifier: "nervio.morning", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: true))
        center.add(request)
    }

    func cancel() {
        UserDefaults.standard.set(false, forKey: "notificationsEnabled")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["nervio.morning"])
    }

    private func body(for value: Int) -> String {
        switch value {
        case 80...100: return "Recovery score: \(value) — Favorable for an active session."
        case 60..<80: return "Recovery score: \(value) — Balanced day ahead."
        case 40..<60: return "Recovery score: \(value) — Consider moderate activity."
        default: return "Recovery score: \(value) — Rest may help today."
        }
    }
}

private extension UserDefaults {
    func contains(_ key: String) -> Bool { object(forKey: key) != nil }
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
                .font(.title2)
                .foregroundStyle(.teal)
                .frame(width: 28, height: 28)
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
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            DashboardView(dashboardState: appModel.dashboardState, permissionState: healthKitManager.permissionState, isLoading: appModel.isLoading, errorMessage: appModel.errorMessage, onRefresh: onRefresh, aiInsight: appModel.aiInsight, isAIInsight: appModel.isAIInsight, isGeneratingInsight: appModel.isGeneratingInsight)
                .opacity(selectedTab == 0 ? 1 : 0)
                .allowsHitTesting(selectedTab == 0)
                .accessibilityHidden(selectedTab != 0)
            TrendsView(dashboardState: appModel.dashboardState)
                .opacity(selectedTab == 1 ? 1 : 0)
                .allowsHitTesting(selectedTab == 1)
                .accessibilityHidden(selectedTab != 1)
            CompareView(dashboardState: appModel.dashboardState, healthKitManager: healthKitManager)
                .opacity(selectedTab == 2 ? 1 : 0)
                .allowsHitTesting(selectedTab == 2)
                .accessibilityHidden(selectedTab != 2)
            AppSettingsView(
                selectedLanguageCode: $selectedLanguageCode,
                selectedTheme: $selectedTheme,
                permissionState: healthKitManager.permissionState,
                onRequestAccess: {
                    await healthKitManager.requestReadAuthorization()
                    await onRefresh()
                },
                onResetOnboarding: onResetOnboarding
            )
            .opacity(selectedTab == 3 ? 1 : 0)
            .allowsHitTesting(selectedTab == 3)
            .accessibilityHidden(selectedTab != 3)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            NervioTabBar(selectedTab: $selectedTab)
                .contentShape(Rectangle())
        }
    }
}

private let nervioBottomBarScrollClearance: CGFloat = 96

private struct NervioTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var glassNamespace

    private let items: [(label: String, icon: String, index: Int)] = [
        ("Today",    "gauge.with.dots.needle.67percent", 0),
        ("Trends",   "chart.xyaxis.line",                1),
        ("Compare",  "arrow.left.and.right.circle",      2),
        ("Settings", "gearshape",                        3),
    ]

    var body: some View {
        if #available(iOS 26.0, *) {
            modernBar
        } else {
            legacyBar
        }
    }

    @available(iOS 26.0, *)
    private var modernBar: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                ForEach(items, id: \.index) { item in
                    pill(for: item)
                        .glassEffect(
                            selectedTab == item.index ? .regular : .clear,
                            in: .capsule
                        )
                        .glassEffectID(item.index, in: glassNamespace)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }

    private var legacyBar: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.index) { item in
                pill(for: item)
                    .background(
                        Capsule()
                            .fill(selectedTab == item.index
                                ? Color.primary.opacity(0.12)
                                : Color.clear)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private func pill(for item: (label: String, icon: String, index: Int)) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3, bounce: 0.25)) {
                selectedTab = item.index
            }
        } label: {
            HStack(spacing: selectedTab == item.index ? 6 : 0) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 22)
                if selectedTab == item.index {
                    Text(L10n.string(item.label))
                        .font(.subheadline.weight(.semibold))
                        .fixedSize()
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.8, anchor: .leading)),
                            removal: .opacity.combined(with: .scale(scale: 0.8, anchor: .leading))
                        ))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, selectedTab == item.index ? 20 : 16)
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .foregroundStyle(selectedTab == item.index ? Color.primary : Color.primary.opacity(0.45))
        .animation(.spring(duration: 0.3, bounce: 0.25), value: selectedTab)
    }
}

struct AppSettingsView: View {
    @Binding var selectedLanguageCode: String
    @Binding var selectedTheme: String
    let permissionState: HealthPermissionState
    let onRequestAccess: () async -> Void
    let onResetOnboarding: () -> Void
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationHour") private var notificationHour = 8
    @AppStorage("notificationMinute") private var notificationMinute = 0
    @AppStorage("hasAcceptedReviewPrompt") private var hasAcceptedReviewPrompt = false
    @AppStorage("liveActivitiesEnabled") private var liveActivitiesEnabled = false
    @State private var showingPaywall = false
    @Environment(\.openURL) private var openURL

    private var notificationTime: Binding<Date> {
        Binding {
            Calendar.current.date(from: DateComponents(hour: notificationHour, minute: notificationMinute)) ?? Date()
        } set: { newDate in
            notificationHour = Calendar.current.component(.hour, from: newDate)
            notificationMinute = Calendar.current.component(.minute, from: newDate)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                    // MARK: Pro section
                    if NervioProManager.shared.isPro {
                        Section {
                            HStack {
                                Label(L10n.string("Nervio Pro"), systemImage: "sparkles")
                                Spacer()
                                Text(L10n.string("Active"))
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.green)
                            }
                        } header: {
                            Text("Pro")
                        }
                    } else {
                        Section {
                            Button { showingPaywall = true } label: {
                                HStack {
                                    Label(L10n.string("Unlock Nervio Pro"), systemImage: "sparkles")
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Text(NervioProManager.shared.displayPrice)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.green)
                                }
                            }
                        } header: {
                            Text("Pro")
                        } footer: {
                            Text(L10n.string("Home Screen widgets, Live Activity and all future Pro features. One-time purchase."))
                                .font(.footnote)
                        }
                    }

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

                    Section {
                        Toggle(L10n.string("Morning notification"), isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) {
                                if notificationsEnabled {
                                    Task { await NervioNotificationManager.shared.requestPermission() }
                                } else {
                                    NervioNotificationManager.shared.cancel()
                                }
                            }
                        if notificationsEnabled {
                            DatePicker(L10n.string("Time"), selection: notificationTime, displayedComponents: .hourAndMinute)
                        }
                    } header: {
                        Text(L10n.string("Daily Reminder"))
                    } footer: {
                        Text(L10n.string("A daily nudge at your chosen time showing your latest recovery score and a short readiness summary — no account needed, all data stays on your device."))
                            .font(.footnote)
                    }

                    // MARK: Live Activity section
                    Section {
                        if NervioProManager.shared.isPro {
                            Toggle(isOn: $liveActivitiesEnabled) {
                                Label(L10n.string("Live Activity"), systemImage: "circle.dotted.and.circle")
                            }
                            .onChange(of: liveActivitiesEnabled) { _, newValue in
                                if newValue {
                                    let snapshot = NervioWidgetSnapshotStore.load()
                                    NervioLiveActivityManager.shared.startOrUpdate(with: snapshot)
                                } else {
                                    NervioLiveActivityManager.shared.endAll()
                                }
                            }
                        } else {
                            Button { showingPaywall = true } label: {
                                HStack {
                                    Label(L10n.string("Live Activity"), systemImage: "circle.dotted.and.circle")
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    HStack(spacing: 5) {
                                        Text("PRO")
                                            .font(.system(size: 10, weight: .bold, design: .rounded))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(.green, in: Capsule())
                                        Image(systemName: "lock.fill")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    } header: {
                        Text(L10n.string("Live Activity"))
                    } footer: {
                        Text(NervioProManager.shared.isPro
                             ? L10n.string("Shows your recovery score in Dynamic Island and on the Lock Screen throughout the day.")
                             : L10n.string("Requires Nervio Pro. Shows your recovery score in Dynamic Island and on the Lock Screen."))
                            .font(.footnote)
                    }

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

                    Section(L10n.string("Support")) {
                        Button {
                            hasAcceptedReviewPrompt = true
                            openAppStoreReview()
                        } label: {
                            Label(L10n.string("Leave a Review"), systemImage: "star.bubble")
                        }
                    }

                    Section {
                        Text(L10n.string("Nervio estimates wellness-oriented recovery signals from available Apple Health data. It does not diagnose stress, burnout, illness, or any medical condition."))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: nervioBottomBarScrollClearance)
                }
                .background { NervioBackground() }
            .navigationTitle(L10n.string("Settings"))
            .sheet(isPresented: $showingPaywall) {
                ProPaywallView()
            }
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

    private func openAppStoreReview() {
        guard let reviewURL = AppStoreReviewLink.writeReviewURL else { return }
        openURL(reviewURL)
    }
}

struct DashboardView: View {
    let dashboardState: DashboardState
    let permissionState: HealthPermissionState
    let isLoading: Bool
    let errorMessage: String?
    let onRefresh: () async -> Void
    var aiInsight: String? = nil
    var isAIInsight: Bool = false
    var isGeneratingInsight: Bool = false

    @State private var showingPaywall = false

    private var recoveryTint: Color {
        semanticRecoveryColors(for: dashboardState.score.value).first ?? .teal
    }

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
                        InsightCard(insight: aiInsight, isAI: isAIInsight, isGenerating: isGeneratingInsight)
                        MoodLogCard(scoreValue: dashboardState.score.value)
                        TodayMetricsView(dashboardState: dashboardState)
                        ContributorsView(contributors: dashboardState.score.contributors)
                    }
                    .padding(.horizontal, NervioVisuals.horizontalPadding)
                    .padding(.top, 20)
                    .padding(.bottom, nervioBottomBarScrollClearance)
            }
            .background { NervioBackground(tint: recoveryTint) }
            .navigationTitle(L10n.string("Today"))
            .toolbar {
                if !NervioProManager.shared.isPro {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { showingPaywall = true } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 9, weight: .bold))
                                Text("PRO")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(
                                LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing),
                                in: Capsule()
                            )
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await onRefresh() } } label: { Image(systemName: "arrow.clockwise") }
                        .disabled(isLoading)
                        .accessibilityLabel(L10n.string("Refresh Health data"))
                }
            }
            .refreshable { await onRefresh() }
            .sheet(isPresented: $showingPaywall) {
                ProPaywallView()
            }
        }
    }
}

private struct ScoreHeader: View {
    let score: RecoveryScore
    @State private var ringProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Text(score.status.localizedTitle)
                .font(.caption2.weight(.bold))
                .textCase(.uppercase)
                .tracking(1.0)
                .foregroundStyle(recoveryTint)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(recoveryTint.opacity(0.15), in: Capsule())
                .padding(.bottom, 26)

            ZStack {
                Circle()
                    .stroke(.primary.opacity(0.06), lineWidth: 18)
                Circle()
                    .fill(recoveryTint.opacity(0.05))
                    .padding(12)
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        LinearGradient(
                            colors: recoveryGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(duration: 1.4, bounce: 0.15).delay(0.1), value: ringProgress)

                VStack(spacing: 2) {
                    Text(score.value.map(String.init) ?? "--")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                    if score.value != nil {
                        Text("/ 100")
                            .font(.system(.callout, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(width: 192, height: 192)
            .padding(.bottom, 24)

            Text(score.summary)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 12)
                .padding(.bottom, 16)

            Text(
                L10n.format(
                    "Based on %d baseline days. This is a wellness signal, not a diagnosis or medical conclusion.",
                    score.baselineDays
                )
            )
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .nervioCard(tint: recoveryTint, padding: 24)
        .onAppear {
            ringProgress = scoreRingProgress(for: score.value)
        }
        .onChange(of: score.value) { _, newValue in
            ringProgress = scoreRingProgress(for: newValue)
        }
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
    @State private var ringProgress: CGFloat = 0

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            ZStack {
                Circle()
                    .stroke(.primary.opacity(0.06), lineWidth: 12)
                Circle()
                    .fill(stressTint.opacity(0.06))
                    .padding(8)
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        LinearGradient(colors: stressGradientColors, startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(duration: 1.2, bounce: 0.15).delay(0.3), value: ringProgress)
                Text(stressScore.value.map(String.init) ?? "--")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
            }
            .frame(width: 96, height: 96)

            VStack(alignment: .leading, spacing: 5) {
                Text(L10n.string("Stress / load score"))
                    .font(.subheadline.weight(.semibold))
                Text(stressScore.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(L10n.string("Higher means available data may indicate more physiological load."))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 0)
        }
        .nervioCard(tint: stressTint, padding: 16)
        .onAppear {
            ringProgress = scoreRingProgress(for: stressScore.value)
        }
        .onChange(of: stressScore.value) { _, newValue in
            ringProgress = scoreRingProgress(for: newValue)
        }
    }

    private var stressTint: Color {
        semanticStressColors(for: stressScore.value).first ?? .orange
    }

    private var stressGradientColors: [Color] {
        semanticStressColors(for: stressScore.value)
    }
}

private func scoreRingProgress(for value: Int?) -> CGFloat {
    let boundedValue = min(100, max(0, value ?? 0))
    return CGFloat(boundedValue) / 100
}

private func semanticRecoveryColors(for value: Int?) -> [Color] {
    guard let value else { return [.teal, .mint] }

    switch value {
    case 70...100:
        return [.green, .mint]
    case 52..<70:
        return [.yellow, .green]
    case 35..<52:
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
                MetricTile(title: L10n.string("Steps"), value: summary?.stepCount.map { Self.stepsFormatter.string(from: NSNumber(value: Int($0.rounded()))) ?? "\(Int($0.rounded()))" } ?? "--", icon: "figure.walk", tint: .green)
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
                    .font(.title2)
                    .foregroundStyle(tint)
                    .frame(width: 28, height: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(L10n.string("Activity Load"))
                        .font(.subheadline.weight(.semibold))
                    Text(activityLoad?.label ?? L10n.string("No step data available."))
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
                .font(.title2)
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
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
                            .font(.title2)
                            .foregroundStyle(color(for: contributor.direction))
                            .frame(width: 28, height: 28)
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
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 28, height: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(message).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .nervioCard(tint: .orange, padding: 14)
    }
}

private struct InsightCard: View {
    let insight: String?
    let isAI: Bool
    let isGenerating: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                Text(isAI ? "Apple Intelligence" : L10n.string("Today's insight"))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.purple)
                Spacer()
                if isGenerating {
                    ProgressView().scaleEffect(0.7)
                }
            }

            if let insight {
                Text(insight)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            } else {
                Text("—")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nervioCard(tint: .purple, padding: 16)
        .animation(.easeInOut(duration: 0.3), value: insight)
    }
}

private struct MoodLogCard: View {
    @AppStorage("moodLogJSON") private var moodLogJSON = "{}"
    let scoreValue: Int?

    private struct MoodLevel {
        let symbol: String
        let label: String
        let color: Color
    }

    private static let levels: [MoodLevel] = [
        MoodLevel(symbol: "moon.zzz.fill",     label: "Drained", color: .indigo),
        MoodLevel(symbol: "waveform.path.ecg", label: "Low",     color: .blue),
        MoodLevel(symbol: "waveform",          label: "Steady",  color: .teal),
        MoodLevel(symbol: "bolt.heart.fill",   label: "Strong",  color: .green),
        MoodLevel(symbol: "flame.fill",        label: "Primed",  color: .orange),
    ]

    private var todayKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f.string(from: Date())
    }
    private var moodLog: [String: Int] {
        guard let data = moodLogJSON.data(using: .utf8),
              let dict = try? JSONDecoder().decode([String: Int].self, from: data) else { return [:] }
        return dict
    }
    private var todayMood: Int? { moodLog[todayKey] }

    private func logMood(_ level: Int) {
        var log = moodLog
        log[todayKey] = level
        if let data = try? JSONEncoder().encode(log), let json = String(data: data, encoding: .utf8) {
            moodLogJSON = json
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.string("How do you feel today?"))
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 6) {
                ForEach(0..<5) { i in
                    let level = Self.levels[i]
                    let isSelected = todayMood == i + 1
                    Button {
                        withAnimation(.spring(duration: 0.3)) { logMood(i + 1) }
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: level.symbol)
                                .font(.title3)
                                .foregroundStyle(isSelected ? level.color : .secondary)
                                .scaleEffect(isSelected ? 1.25 : 1.0)
                                .animation(.spring(duration: 0.3), value: todayMood)
                            Text(level.label)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(isSelected ? level.color : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            isSelected
                                ? level.color.opacity(0.14)
                                : Color.primary.opacity(0.04),
                            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(isSelected ? level.color.opacity(0.4) : .clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            if let mood = todayMood, let score = scoreValue {
                let corr = moodScoreCorrelation()
                if let corr {
                    Text(corr)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                let _ = (mood, score)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nervioCard(tint: .purple, padding: 16)
    }

    private func moodScoreCorrelation() -> String? {
        let log = moodLog
        guard log.count >= 5 else { return nil }
        let highMoodDays = log.values.filter { $0 >= 4 }.count
        let totalDays = log.count
        let pct = Int(Double(highMoodDays) / Double(totalDays) * 100)
        return L10n.format("You felt energized or good on %d%% of tracked days.", pct)
    }
}

struct TrendsView: View {
    let dashboardState: DashboardState

    var body: some View {
        let recentHistory = Array(dashboardState.history.suffix(28))
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    RecoveryCalendarView(scoreHistory: dashboardState.scoreHistory)
                    RecoveryScoreChart(scoreHistory: Array(dashboardState.scoreHistory.suffix(28)))
                    TrendChart(title: L10n.string("HRV"), unit: L10n.string("ms"), color: .teal, points: recentHistory.compactMap { summary in summary.hrvMilliseconds.map { TrendPoint(date: summary.date, value: $0) } })
                    TrendChart(title: L10n.string("Resting heart rate"), unit: L10n.string("bpm"), color: .pink, points: recentHistory.compactMap { summary in summary.restingHeartRate.map { TrendPoint(date: summary.date, value: $0) } })
                    TrendChart(title: L10n.string("Sleep"), unit: L10n.string("hours"), color: .indigo, points: recentHistory.compactMap { summary in summary.sleepHours.map { TrendPoint(date: summary.date, value: $0) } })
                    TrendChart(title: L10n.string("Steps"), unit: L10n.string("steps"), color: .green, points: recentHistory.compactMap { summary in summary.stepCount.map { TrendPoint(date: summary.date, value: $0) } })
                    Text(L10n.string("Trends compare available Apple Health samples over time. Missing points usually mean no readable data was available for that day."))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .nervioCard(tint: .indigo, padding: 14)
                }
                .padding(.horizontal, NervioVisuals.horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, nervioBottomBarScrollClearance)
            }
            .background { NervioBackground() }
            .navigationTitle(L10n.string("Trends"))
        }
    }
}

private struct RecoveryCalendarView: View {
    let scoreHistory: [DailyScorePoint]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L10n.string("Recovery calendar"))
                    .font(.headline.weight(.semibold))
                Spacer()
                Text(L10n.string(pastWeekCountLabel))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 4) {
                // Use enumerated index as ID to avoid duplicates (T=Tue/Thu, S=Sun/Sat)
                ForEach(Array(Calendar.current.veryShortWeekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
                ForEach(Array(calendarDays.enumerated()), id: \.offset) { _, point in
                    let isToday = Calendar.current.isDateInToday(point.date)
                    let isFuture = point.date > Calendar.current.startOfDay(for: Date())
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(isFuture ? Color.clear : calendarColor(for: point.value))
                        .frame(height: 26)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .strokeBorder(
                                    isToday ? Color.teal : Color.primary.opacity(isFuture ? 0.03 : 0.07),
                                    lineWidth: isToday ? 2 : 0.5
                                )
                        )
                }
            }

            HStack(spacing: 8) {
                legendItem(color: Color.primary.opacity(0.1), label: L10n.string("No data"))
                legendItem(color: .red.opacity(0.65), label: "< 40")
                legendItem(color: .orange.opacity(0.7), label: "40–59")
                legendItem(color: .yellow.opacity(0.75), label: "60–79")
                legendItem(color: .green.opacity(0.75), label: "≥ 80")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nervioCard(tint: .teal, padding: 16)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3).fill(color).frame(width: 10, height: 10)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }

    private var pastWeekCountLabel: String {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekday == 7 ? "6 weeks" : "5 weeks"
    }

    private var calendarDays: [DailyScorePoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)  // 1=Sun … 7=Sat
        let daysFromSunday = weekday - 1
        // Start from the Sunday 5 weeks before this week's Sunday; stop at today (no future cells)
        guard let lastSunday = calendar.date(byAdding: .day, value: -daysFromSunday, to: today),
              let gridStart = calendar.date(byAdding: .day, value: -35, to: lastSunday) else { return [] }

        let scoreMap: [Date: Int] = Dictionary(
            uniqueKeysWithValues: scoreHistory.compactMap { point -> (Date, Int)? in
                guard let value = point.value else { return nil }
                return (calendar.startOfDay(for: point.date), value)
            }
        )

        // 5 complete past rows + current week up to today (no future cells)
        let cellCount = 36 + daysFromSunday
        return (0..<cellCount).compactMap { offset -> DailyScorePoint? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: gridStart) else { return nil }
            return DailyScorePoint(date: date, value: scoreMap[date])
        }
    }

    private func calendarColor(for value: Int?) -> Color {
        guard let value else { return Color.primary.opacity(0.1) }
        switch value {
        case 80...100: return .green.opacity(0.75)
        case 60..<80: return .yellow.opacity(0.75)
        case 40..<60: return .orange.opacity(0.7)
        default: return .red.opacity(0.65)
        }
    }
}

private struct RecoveryScoreChart: View {
    let scoreHistory: [DailyScorePoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.string("Recovery score"))
                        .font(.headline.weight(.semibold))
                    Text(L10n.string("Last 28 days"))
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if let latest = scoreHistory.last?.value {
                    Text("\(latest)")
                        .font(.subheadline.monospacedDigit().weight(.semibold))
                }
            }

            if scoreHistory.compactMap(\.value).isEmpty {
                Text(L10n.string("No readable data yet"))
                    .font(.subheadline).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 160)
            } else {
                let indexed = Array(scoreHistory.enumerated())
                Chart(indexed, id: \.element.id) { index, point in
                    if let v = point.value {
                        BarMark(
                            x: .value("Date", index),
                            yStart: .value("Score", 0),
                            yEnd: .value("Score", v)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .foregroundStyle(scoreGradient(for: v))

                        if point.id == scoreHistory.last?.id {
                            PointMark(x: .value("Date", index), y: .value("Score", v))
                                .foregroundStyle(scoreColor(for: v))
                                .symbolSize(28)
                        }
                    }
                    RuleMark(y: .value("Baseline", averageScore))
                        .foregroundStyle(.secondary.opacity(0.30))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }
                .chartYScale(domain: 0...100)
                .chartXScale(domain: -0.5...Double(max(scoreHistory.count - 1, 0)) + 0.5)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [2, 4]))
                            .foregroundStyle(.white.opacity(0.10))
                        AxisValueLabel().font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [0, 25, 50, 75, 100]) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [2, 4]))
                            .foregroundStyle(.white.opacity(0.10))
                        AxisValueLabel().font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .chartPlotStyle { $0.background(.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 12)) }
                .frame(height: 200)
            }
        }
        .nervioCard(tint: .teal, padding: 16)
    }

    private var averageScore: Double {
        let vals = scoreHistory.compactMap(\.value).map(Double.init)
        guard !vals.isEmpty else { return 70 }
        return vals.reduce(0, +) / Double(vals.count)
    }

    private func scoreColor(for value: Int) -> Color {
        semanticRecoveryColors(for: value).first ?? .teal
    }

    private func scoreGradient(for value: Int) -> LinearGradient {
        let colors = semanticRecoveryColors(for: value)
        return LinearGradient(colors: [colors[0].opacity(0.45), colors[0].opacity(0.9)], startPoint: .bottom, endPoint: .top)
    }
}

struct CompareView: View {
    let dashboardState: DashboardState
    let healthKitManager: HealthKitManager
    private let calendar = Calendar.current
    @State private var scope: CompareScope = .month
    @State private var availableYears: [Int] = []
    @State private var yearA: Int = 0
    @State private var yearB: Int = 0
    @State private var comparison: StepPeriodComparison?
    @State private var isLoadingCompare = false
    @State private var isDetectingYears = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("Compare Scope", selection: $scope) {
                        ForEach(CompareScope.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)

                    if isDetectingYears {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 8)
                    } else if availableYears.count >= 2 {
                        yearPickerRow(label: L10n.string("Compare"), selected: $yearA, excluding: yearB)
                        yearPickerRow(label: L10n.string("with"), selected: $yearB, excluding: yearA)
                    }

                    Text(scope.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if isLoadingCompare {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .nervioCard(tint: .teal, padding: 14)
                    } else if let comparison {
                        compareCard(comparison: comparison)
                    } else if !isDetectingYears {
                        Text(L10n.string("Not enough historical data yet for year-over-year comparison."))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .nervioCard(tint: .orange, padding: 14)
                    }
                }
                .padding(.horizontal, NervioVisuals.horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, nervioBottomBarScrollClearance)
            }
            .background { NervioBackground() }
            .navigationTitle(L10n.string("Compare"))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                guard availableYears.isEmpty else { return }
                await detectAvailableYears()
                await loadComparison()
            }
            .onChange(of: scope) { Task { await loadComparison() } }
            .onChange(of: yearA) { Task { await loadComparison() } }
            .onChange(of: yearB) { Task { await loadComparison() } }
        }
    }

    private func yearPickerRow(label: String, selected: Binding<Int>, excluding: Int) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 58, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(availableYears.filter { $0 != excluding }, id: \.self) { year in
                        Button {
                            selected.wrappedValue = year
                        } label: {
                            Text(String(year))
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selected.wrappedValue == year ? Color.teal : Color.primary.opacity(0.08),
                                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                                )
                                .foregroundStyle(selected.wrappedValue == year ? Color.white : Color.primary)
                        }
                        .buttonStyle(.plain)
                        .animation(.easeInOut(duration: 0.15), value: selected.wrappedValue)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func compareCard(comparison: StepPeriodComparison) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(L10n.string("Steps"), systemImage: "figure.walk")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text(comparison.percentText)
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(comparison.delta >= 0 ? Color.green : Color.orange)
            }

            Text(comparison.summaryText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(comparison.currentRangeLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(comparison.thisAmountText)
                        .font(.title3.monospacedDigit().weight(.semibold))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(comparison.previousRangeLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(comparison.previousAmountText)
                        .font(.title3.monospacedDigit().weight(.semibold))
                }
            }
        }
        .nervioCard(tint: .green, padding: 14)
    }

    private func detectAvailableYears() async {
        isDetectingYears = true
        defer { isDetectingYears = false }

        let cal = calendar
        let cur = cal.component(.year, from: Date())
        let hkm = healthKitManager

        @Sendable func has(year: Int) async -> Bool {
            guard let s = cal.date(from: DateComponents(year: year, month: 1, day: 1)),
                  let e = cal.date(byAdding: .year, value: 1, to: s) else { return false }
            return ((await hkm.fetchAppleWatchStepTotal(startDate: s, endDate: e)) ?? 0) > 0
        }

        async let r0 = has(year: cur)
        async let r1 = has(year: cur - 1)
        async let r2 = has(year: cur - 2)
        async let r3 = has(year: cur - 3)
        async let r4 = has(year: cur - 4)
        async let r5 = has(year: cur - 5)
        async let r6 = has(year: cur - 6)

        let flags = await [r0, r1, r2, r3, r4, r5, r6]
        var years: [Int] = []
        for (offset, hasData) in flags.enumerated() where hasData {
            years.append(cur - offset)
        }

        availableYears = years
        if years.count >= 2 {
            yearA = years[0]
            yearB = years[1]
        }
    }

    private func loadComparison() async {
        guard yearA != 0, yearB != 0, yearA != yearB else { comparison = nil; return }
        isLoadingCompare = true
        defer { isLoadingCompare = false }

        let now = Date()
        let todayStart = calendar.startOfDay(for: now)
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: todayStart) else { comparison = nil; return }
        let currentYear = calendar.component(.year, from: now)

        let startA, endA, startB, endB: Date

        switch scope {
        case .month:
            let month = calendar.component(.month, from: now)
            // Use byAdding:.year to handle leap-year edge cases automatically
            guard let mStartCurrent = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)),
                  let diffATomorrow  = calendar.date(byAdding: .year, value: yearA - currentYear, to: tomorrow),
                  let diffBTomorrow  = calendar.date(byAdding: .year, value: yearB - currentYear, to: tomorrow),
                  let mStartA = calendar.date(byAdding: .year, value: yearA - currentYear, to: mStartCurrent),
                  let mStartB = calendar.date(byAdding: .year, value: yearB - currentYear, to: mStartCurrent)
            else { comparison = nil; return }
            (startA, endA) = (mStartA, diffATomorrow)
            (startB, endB) = (mStartB, diffBTomorrow)

        case .yearToDate:
            guard let janA = calendar.date(from: DateComponents(year: yearA, month: 1, day: 1)),
                  let janB = calendar.date(from: DateComponents(year: yearB, month: 1, day: 1)),
                  let endATomorrow = calendar.date(byAdding: .year, value: yearA - currentYear, to: tomorrow),
                  let endBTomorrow = calendar.date(byAdding: .year, value: yearB - currentYear, to: tomorrow)
            else { comparison = nil; return }
            (startA, endA) = (janA, endATomorrow)
            (startB, endB) = (janB, endBTomorrow)

        case .fullYear:
            guard let janA   = calendar.date(from: DateComponents(year: yearA, month: 1, day: 1)),
                  let endAY  = calendar.date(byAdding: .year, value: 1, to: janA),
                  let janB   = calendar.date(from: DateComponents(year: yearB, month: 1, day: 1)),
                  let endBY  = calendar.date(byAdding: .year, value: 1, to: janB)
            else { comparison = nil; return }
            (startA, endA) = (janA, endAY)
            (startB, endB) = (janB, endBY)
        }

        async let fetchA = healthKitManager.fetchAppleWatchStepTotal(startDate: startA, endDate: endA)
        async let fetchB = healthKitManager.fetchAppleWatchStepTotal(startDate: startB, endDate: endB)
        let (stepsA, stepsB) = await (fetchA, fetchB)

        guard let stepsA, let stepsB, stepsA > 0, stepsB > 0 else { comparison = nil; return }

        comparison = StepPeriodComparison(
            thisAmount: stepsA, previousAmount: stepsB,
            currentStart: startA, currentEnd: endA,
            previousStart: startB, previousEnd: endB,
            yearA: yearA, yearB: yearB
        )
    }
}

private enum CompareScope: String, CaseIterable, Identifiable {
    case month
    case yearToDate
    case fullYear

    var id: String { rawValue }

    var title: String {
        switch self {
        case .month:      return L10n.string("Month")
        case .yearToDate: return L10n.string("Year")
        case .fullYear:   return L10n.string("Full year")
        }
    }

    var subtitle: String {
        switch self {
        case .month:      return L10n.string("Same month, same days — year over year")
        case .yearToDate: return L10n.string("Jan 1 to today — year over year")
        case .fullYear:   return L10n.string("Full calendar year (Jan – Dec)")
        }
    }
}

private struct StepPeriodComparison {
    let thisAmount: Double
    let previousAmount: Double
    let currentStart: Date
    let currentEnd: Date    // exclusive
    let previousStart: Date
    let previousEnd: Date   // exclusive
    let yearA: Int
    let yearB: Int

    var delta: Double { thisAmount - previousAmount }

    var percentDelta: Double {
        guard previousAmount > 0 else { return 0 }
        return (delta / previousAmount) * 100
    }

    var percentText: String {
        let sign = percentDelta >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", percentDelta))%"
    }

    var summaryText: String {
        let diff = formatted(abs(delta))
        return delta >= 0
            ? "\(yearA) had \(diff) more steps than \(yearB) for the same period."
            : "\(yearA) had \(diff) fewer steps than \(yearB) for the same period."
    }

    var thisAmountText: String    { formatted(thisAmount) }
    var previousAmountText: String { formatted(previousAmount) }

    var currentRangeLabel: String  { formatRange(currentStart,  currentEnd) }
    var previousRangeLabel: String { formatRange(previousStart, previousEnd) }

    // Formats a [start, exclusiveEnd) range as a human-readable date span.
    private func formatRange(_ start: Date, _ exclusiveEnd: Date) -> String {
        let cal = Calendar.current
        let displayEnd = cal.date(byAdding: .day, value: -1, to: exclusiveEnd) ?? exclusiveEnd
        let sy = cal.component(.year, from: start)
        let ey = cal.component(.year, from: displayEnd)
        let sm = cal.component(.month, from: start)
        let em = cal.component(.month, from: displayEnd)
        let df = DateFormatter()
        if sy == ey {
            if sm == em {
                // e.g. "Jun 1–11, 2026"
                df.dateFormat = "MMM d"
                return "\(df.string(from: start))–\(cal.component(.day, from: displayEnd)), \(sy)"
            } else {
                // e.g. "Jan 1–Jun 11, 2026"
                df.dateFormat = "MMM d"
                return "\(df.string(from: start))–\(df.string(from: displayEnd)), \(sy)"
            }
        } else {
            // e.g. "Jan 1–Jun 11, 2025"
            df.dateFormat = "MMM d, yyyy"
            return "\(df.string(from: start))–\(df.string(from: displayEnd))"
        }
    }

    private func formatted(_ value: Double) -> String {
        Self.stepsFormatter.string(from: NSNumber(value: Int(value.rounded()))) ?? "\(Int(value.rounded()))"
    }

    private static let stepsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
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
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                    Text(L10n.string("Last 28 days"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(latestValue)
                        .font(.subheadline.monospacedDigit().weight(.semibold))
                    Text(trendDeltaText)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(trendDeltaColor)
                }
            }

            if points.isEmpty {
                Text(L10n.string("No readable data yet"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                let indexedPoints = Array(points.enumerated())
                Chart(indexedPoints, id: \.element.id) { index, point in
                    RuleMark(y: .value("Average", averageValue))
                        .foregroundStyle(.secondary.opacity(0.35))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    BarMark(
                        x: .value(L10n.string("Date"), index),
                        yStart: .value(title, yDomain.lowerBound),
                        yEnd: .value(title, point.value)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color.opacity(0.42), color.opacity(0.95)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .opacity(point.id == points.last?.id ? 1 : 0.9)

                    if point.id == points.last?.id {
                        PointMark(x: .value(L10n.string("Date"), index), y: .value(title, point.value))
                            .foregroundStyle(color)
                            .symbolSize(26)
                    }
                }
                .chartYScale(domain: yDomain)
                .chartXScale(domain: -0.5...Double(max(points.count - 1, 0)) + 0.5)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [2, 4]))
                            .foregroundStyle(.white.opacity(0.12))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.7))
                            .foregroundStyle(.secondary.opacity(0.45))
                        AxisValueLabel()
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [2, 4]))
                            .foregroundStyle(.white.opacity(0.12))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.7))
                            .foregroundStyle(.secondary.opacity(0.45))
                        AxisValueLabel()
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .frame(height: 205)
            }
        }
        .nervioCard(tint: color, padding: 16)
    }

    private var latestValue: String {
        guard let value = points.last?.value else { return "--" }
        return "\(String(format: "%.1f", value)) \(unit)"
    }

    private var averageValue: Double {
        let values = points.map(\.value)
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    private var trendDeltaText: String {
        guard let first = points.first?.value, let last = points.last?.value else { return "—" }
        let delta = last - first
        let sign = delta >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", delta)) \(unit)"
    }

    private var trendDeltaColor: Color {
        guard let first = points.first?.value, let last = points.last?.value else { return .secondary }
        let delta = last - first
        if abs(delta) < 0.001 { return .secondary }
        return delta > 0 ? .green : .orange
    }

    private var yDomain: ClosedRange<Double> {
        let values = points.map(\.value)
        guard let minValue = values.min(), let maxValue = values.max() else { return 0...1 }
        let spread = max(maxValue - minValue, maxValue == 0 ? 1 : abs(maxValue) * 0.15)
        let padding = spread * 0.22
        return (minValue - padding)...(maxValue + padding)
    }

}

struct PrivacySettingsView: View {
    let permissionState: HealthPermissionState
    let onRequestAccess: () async -> Void
    let onResetOnboarding: () -> Void
    @AppStorage("hasAcceptedReviewPrompt") private var hasAcceptedReviewPrompt = false
    @Environment(\.openURL) private var openURL

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
                    Section(L10n.string("Support")) {
                        Button {
                            hasAcceptedReviewPrompt = true
                            openAppStoreReview()
                        } label: {
                            Label(L10n.string("Leave a Review"), systemImage: "star.bubble")
                        }
                    }
                    Section {
                        Text(L10n.string("Nervio estimates wellness-oriented recovery signals from available Apple Health data. It does not diagnose stress, burnout, illness, or any medical condition."))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: nervioBottomBarScrollClearance)
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

    private func openAppStoreReview() {
        guard let reviewURL = AppStoreReviewLink.writeReviewURL else { return }
        openURL(reviewURL)
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.teal)
                .frame(width: 28, height: 28)
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
