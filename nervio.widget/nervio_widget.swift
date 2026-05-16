import SwiftUI
import WidgetKit

private func w(_ key: String, languageCode: String) -> String {
    WidgetL10n.string(key, languageCode: languageCode)
}

private enum WidgetL10n {
    static func string(_ key: String, languageCode: String) -> String {
        let resolvedCode: String
        if languageCode == "system" {
            resolvedCode = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            resolvedCode = languageCode
        }

        if resolvedCode == "en" {
            return translations["en"]?[key] ?? key
        }

        return translations[resolvedCode]?[key] ?? translations["en"]?[key] ?? key
    }

    private static let translations: [String: [String: String]] = [
        "en": [
            "widget.updated": "Updated",
            "widget.recovery": "Recovery",
            "widget.stress": "Stress",
            "widget.recovery_score": "Recovery Score",
            "widget.stress_score": "Stress Score",
            "widget.load": "Load",
            "widget.rec_short": "Rec",
            "widget.steps": "Apple Watch Steps",
            "widget.config.recovery.title": "Nervio Recovery",
            "widget.config.recovery.desc": "Recovery score, context and key inputs.",
            "widget.config.stress.title": "Nervio Stress",
            "widget.config.stress.desc": "Stress/load score, context and key inputs.",
            "widget.summary.recovery.high": "Strong recovery signal today.",
            "widget.summary.recovery.mid": "Steady recovery signal today.",
            "widget.summary.recovery.low": "Recovery signal is lower today.",
            "widget.summary.stress.high": "Physiological load is elevated today.",
            "widget.summary.stress.mid": "Moderate physiological load today.",
            "widget.summary.stress.low": "Physiological load is lower today.",
            "widget.summary.no_data": "No data yet. Open the app to refresh Health data."
        ],
        "ro": [
            "widget.updated": "Actualizat",
            "widget.recovery": "Recuperare",
            "widget.stress": "Stres",
            "widget.recovery_score": "Scor recuperare",
            "widget.stress_score": "Scor stres",
            "widget.load": "Încărcare",
            "widget.rec_short": "Rec",
            "widget.steps": "Pași Apple Watch",
            "widget.config.recovery.title": "Nervio Recuperare",
            "widget.config.recovery.desc": "Scor recuperare, context și indicatori cheie.",
            "widget.config.stress.title": "Nervio Stres",
            "widget.config.stress.desc": "Scor stres/încărcare, context și indicatori cheie.",
            "widget.summary.recovery.high": "Semnal de recuperare puternic azi.",
            "widget.summary.recovery.mid": "Semnal de recuperare stabil azi.",
            "widget.summary.recovery.low": "Semnalul de recuperare este mai scăzut azi.",
            "widget.summary.stress.high": "Încărcarea fiziologică este ridicată azi.",
            "widget.summary.stress.mid": "Încărcare fiziologică moderată azi.",
            "widget.summary.stress.low": "Încărcarea fiziologică este mai scăzută azi.",
            "widget.summary.no_data": "Încă nu sunt date. Deschide aplicația pentru a actualiza datele Health."
        ],
        "fr": [
            "widget.updated": "Mis à jour",
            "widget.recovery": "Récupération",
            "widget.stress": "Stress",
            "widget.recovery_score": "Score récupération",
            "widget.stress_score": "Score stress",
            "widget.load": "Charge",
            "widget.rec_short": "Réc",
            "widget.steps": "Pas Apple Watch",
            "widget.config.recovery.title": "Nervio Récupération",
            "widget.config.recovery.desc": "Score de récupération, contexte et indicateurs clés.",
            "widget.config.stress.title": "Nervio Stress",
            "widget.config.stress.desc": "Score stress/charge, contexte et indicateurs clés.",
            "widget.summary.recovery.high": "Signal de récupération fort aujourd’hui.",
            "widget.summary.recovery.mid": "Signal de récupération stable aujourd’hui.",
            "widget.summary.recovery.low": "Le signal de récupération est plus faible aujourd’hui.",
            "widget.summary.stress.high": "La charge physiologique est élevée aujourd’hui.",
            "widget.summary.stress.mid": "Charge physiologique modérée aujourd’hui.",
            "widget.summary.stress.low": "La charge physiologique est plus faible aujourd’hui.",
            "widget.summary.no_data": "Pas encore de données. Ouvrez l’application pour actualiser les données Santé."
        ],
        "de": [
            "widget.updated": "Aktualisiert",
            "widget.recovery": "Erholung",
            "widget.stress": "Stress",
            "widget.recovery_score": "Erholungsscore",
            "widget.stress_score": "Stressscore",
            "widget.load": "Belastung",
            "widget.rec_short": "Erh",
            "widget.steps": "Apple Watch Schritte",
            "widget.config.recovery.title": "Nervio Erholung",
            "widget.config.recovery.desc": "Erholungsscore, Kontext und wichtige Eingaben.",
            "widget.config.stress.title": "Nervio Stress",
            "widget.config.stress.desc": "Stress-/Belastungsscore, Kontext und wichtige Eingaben.",
            "widget.summary.recovery.high": "Starkes Erholungssignal heute.",
            "widget.summary.recovery.mid": "Stabiles Erholungssignal heute.",
            "widget.summary.recovery.low": "Das Erholungssignal ist heute niedriger.",
            "widget.summary.stress.high": "Die physiologische Belastung ist heute erhöht.",
            "widget.summary.stress.mid": "Mäßige physiologische Belastung heute.",
            "widget.summary.stress.low": "Die physiologische Belastung ist heute niedriger.",
            "widget.summary.no_data": "Noch keine Daten. Öffne die App, um Health-Daten zu aktualisieren."
        ],
        "es": [
            "widget.updated": "Actualizado",
            "widget.recovery": "Recuperación",
            "widget.stress": "Estrés",
            "widget.recovery_score": "Puntuación recuperación",
            "widget.stress_score": "Puntuación estrés",
            "widget.load": "Carga",
            "widget.rec_short": "Rec",
            "widget.steps": "Pasos Apple Watch",
            "widget.config.recovery.title": "Nervio Recuperación",
            "widget.config.recovery.desc": "Puntuación de recuperación, contexto e indicadores clave.",
            "widget.config.stress.title": "Nervio Estrés",
            "widget.config.stress.desc": "Puntuación de estrés/carga, contexto e indicadores clave.",
            "widget.summary.recovery.high": "Señal de recuperación fuerte hoy.",
            "widget.summary.recovery.mid": "Señal de recuperación estable hoy.",
            "widget.summary.recovery.low": "La señal de recuperación es más baja hoy.",
            "widget.summary.stress.high": "La carga fisiológica está elevada hoy.",
            "widget.summary.stress.mid": "Carga fisiológica moderada hoy.",
            "widget.summary.stress.low": "La carga fisiológica es más baja hoy.",
            "widget.summary.no_data": "Aún no hay datos. Abre la app para actualizar los datos de Salud."
        ],
        "it": [
            "widget.updated": "Aggiornato",
            "widget.recovery": "Recupero",
            "widget.stress": "Stress",
            "widget.recovery_score": "Punteggio recupero",
            "widget.stress_score": "Punteggio stress",
            "widget.load": "Carico",
            "widget.rec_short": "Rec",
            "widget.steps": "Passi Apple Watch",
            "widget.config.recovery.title": "Nervio Recupero",
            "widget.config.recovery.desc": "Punteggio recupero, contesto e indicatori chiave.",
            "widget.config.stress.title": "Nervio Stress",
            "widget.config.stress.desc": "Punteggio stress/carico, contesto e indicatori chiave.",
            "widget.summary.recovery.high": "Segnale di recupero forte oggi.",
            "widget.summary.recovery.mid": "Segnale di recupero stabile oggi.",
            "widget.summary.recovery.low": "Il segnale di recupero è più basso oggi.",
            "widget.summary.stress.high": "Il carico fisiologico è elevato oggi.",
            "widget.summary.stress.mid": "Carico fisiologico moderato oggi.",
            "widget.summary.stress.low": "Il carico fisiologico è più basso oggi.",
            "widget.summary.no_data": "Nessun dato al momento. Apri l’app per aggiornare i dati Salute."
        ],
        "pt": [
            "widget.updated": "Atualizado",
            "widget.recovery": "Recuperação",
            "widget.stress": "Estresse",
            "widget.recovery_score": "Pontuação recuperação",
            "widget.stress_score": "Pontuação estresse",
            "widget.load": "Carga",
            "widget.rec_short": "Rec",
            "widget.steps": "Passos Apple Watch",
            "widget.config.recovery.title": "Nervio Recuperação",
            "widget.config.recovery.desc": "Pontuação de recuperação, contexto e indicadores-chave.",
            "widget.config.stress.title": "Nervio Estresse",
            "widget.config.stress.desc": "Pontuação de estresse/carga, contexto e indicadores-chave.",
            "widget.summary.recovery.high": "Sinal de recuperação forte hoje.",
            "widget.summary.recovery.mid": "Sinal de recuperação estável hoje.",
            "widget.summary.recovery.low": "O sinal de recuperação está mais baixo hoje.",
            "widget.summary.stress.high": "A carga fisiológica está elevada hoje.",
            "widget.summary.stress.mid": "Carga fisiológica moderada hoje.",
            "widget.summary.stress.low": "A carga fisiológica está mais baixa hoje.",
            "widget.summary.no_data": "Ainda não há dados. Abra o app para atualizar os dados de Saúde."
        ]
    ]
}

private enum NervioWidgetSignal {
    case recovery
    case stress
}

private struct NervioWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: NervioWidgetSnapshot
}

private struct NervioWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> NervioWidgetEntry {
        NervioWidgetEntry(date: .now, snapshot: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (NervioWidgetEntry) -> Void) {
        let snapshot = context.isPreview ? NervioWidgetSnapshot.preview : NervioWidgetSnapshotStore.load()
        completion(NervioWidgetEntry(date: .now, snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NervioWidgetEntry>) -> Void) {
        let entry = NervioWidgetEntry(date: .now, snapshot: NervioWidgetSnapshotStore.load())
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: .now) ?? .now.addingTimeInterval(600)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }
}

private struct NervioSignalWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @AppStorage("selectedLanguageCode", store: UserDefaults(suiteName: "group.com.florinsima.Nervio-Recovery-Signals")) private var selectedLanguageCode = "system"

    let entry: NervioWidgetEntry
    let signal: NervioWidgetSignal

    private var widgetLanguageCode: String {
        let code = selectedLanguageCode.isEmpty ? (entry.snapshot.languageCode ?? "system") : selectedLanguageCode
        return code.isEmpty ? "system" : code
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallBody
        case .systemLarge:
            largeBody
        default:
            mediumBody
        }
    }

    private var smallBody: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerLine
            ring
                .frame(width: 62, height: 62)
                .frame(maxWidth: .infinity)
            Text(smallPrimaryLine)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Text(smallSecondaryLine)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var mediumBody: some View {
        HStack(spacing: 12) {
            ring
                .frame(width: 74, height: 74)

            VStack(alignment: .leading, spacing: 6) {
                headerLine
                Text(mainValueLine)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                Text(secondaryLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack(spacing: 10) {
                    Label(entry.snapshot.steps.value, systemImage: "figure.walk")
                        .font(.caption2)
                        .lineLimit(1)
                    Label(entry.snapshot.hrv.value, systemImage: "waveform.path.ecg")
                        .font(.caption2)
                        .lineLimit(1)
                }
            }
        }
        .padding(14)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var largeBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 4)

            HStack {
                headerLine
                Spacer()
                Text("\(w("widget.updated", languageCode: widgetLanguageCode)) \(entry.snapshot.updatedAt, style: .time)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 6)

            HStack(alignment: .top, spacing: 12) {
                ring
                    .frame(width: 96, height: 96)

                VStack(alignment: .leading, spacing: 5) {
                    Text(largePrimaryLine)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    Text(localizedSummary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 6)

            HStack(spacing: 8) {
                metricChip(title: entry.snapshot.hrv.title, value: entry.snapshot.hrv.value, symbol: entry.snapshot.hrv.symbolName)
                metricChip(title: entry.snapshot.restingHeartRate.title, value: entry.snapshot.restingHeartRate.value, symbol: entry.snapshot.restingHeartRate.symbolName)
                metricChip(title: entry.snapshot.steps.title, value: entry.snapshot.steps.value, symbol: entry.snapshot.steps.symbolName)
            }

            Spacer(minLength: 2)

            HStack(spacing: 10) {
                Label(entry.snapshot.sleep.value, systemImage: entry.snapshot.sleep.symbolName)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text("R \(entry.snapshot.recoveryValue.map(String.init) ?? "--")")
                Text("S \(entry.snapshot.stressValue.map(String.init) ?? "--")")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Spacer(minLength: 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 12)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var headerLine: some View {
        Text(signal == .recovery ? w("widget.recovery", languageCode: widgetLanguageCode) : w("widget.stress", languageCode: widgetLanguageCode))
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }

    private var ring: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 9)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: 1) {
                Text(valueText)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
        }
    }

    private func metricChip(title: String, value: String, symbol: String) -> some View {
        let localizedTitle = localizedMetricTitle(from: title)
        return VStack(alignment: .leading, spacing: 4) {
            Label(localizedTitle, systemImage: symbol)
                .font(.caption2)
                .lineLimit(1)
            Text(value)
                .font(.headline.monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
    }

    private func localizedMetricTitle(from title: String) -> String {
        let normalized = title.lowercased()
        if normalized.contains("hrv") { return "HRV" }
        if normalized.contains("resting") { return "R-HR" }
        if normalized.contains("sleep") { return w("Sleep", languageCode: widgetLanguageCode) }
        if normalized.contains("step") { return "Steps" }
        return title
    }

    private var score: Int? {
        switch signal {
        case .recovery:
            return entry.snapshot.recoveryValue
        case .stress:
            return entry.snapshot.stressValue
        }
    }

    private var progress: CGFloat {
        CGFloat(Double(score ?? 0) / 100.0)
    }

    private var valueText: String {
        score.map(String.init) ?? "--"
    }

    private var color: Color {
        if signal == .recovery { return .teal }
        return .orange
    }

    private var mainValueLine: String {
        switch signal {
        case .recovery:
            return score.map { "\(w("widget.recovery_score", languageCode: widgetLanguageCode)) \($0)" } ?? "\(w("widget.recovery_score", languageCode: widgetLanguageCode)) --"
        case .stress:
            return score.map { "\(w("widget.stress_score", languageCode: widgetLanguageCode)) \($0)" } ?? "\(w("widget.stress_score", languageCode: widgetLanguageCode)) --"
        }
    }

    private var largePrimaryLine: String {
        switch signal {
        case .recovery:
            if let value = score { return "\(w("widget.recovery_score", languageCode: widgetLanguageCode)) \(value)" }
            return w("widget.recovery_score", languageCode: widgetLanguageCode)
        case .stress:
            if let value = score { return "\(w("widget.stress_score", languageCode: widgetLanguageCode)) \(value)" }
            return w("widget.stress_score", languageCode: widgetLanguageCode)
        }
    }

    private var secondaryLine: String {
        switch signal {
        case .recovery:
            return "\(w("widget.load", languageCode: widgetLanguageCode)) \(entry.snapshot.stressValue.map(String.init) ?? "--")"
        case .stress:
            return "\(w("widget.recovery", languageCode: widgetLanguageCode)) \(entry.snapshot.recoveryValue.map(String.init) ?? "--")"
        }
    }

    private var localizedSummary: String {
        guard let value = score else {
            return w("widget.summary.no_data", languageCode: widgetLanguageCode)
        }

        switch signal {
        case .recovery:
            if value >= 70 { return w("widget.summary.recovery.high", languageCode: widgetLanguageCode) }
            if value >= 40 { return w("widget.summary.recovery.mid", languageCode: widgetLanguageCode) }
            return w("widget.summary.recovery.low", languageCode: widgetLanguageCode)
        case .stress:
            if value >= 70 { return w("widget.summary.stress.high", languageCode: widgetLanguageCode) }
            if value >= 40 { return w("widget.summary.stress.mid", languageCode: widgetLanguageCode) }
            return w("widget.summary.stress.low", languageCode: widgetLanguageCode)
        }
    }

    private var smallPrimaryLine: String {
        switch signal {
        case .recovery:
            return "\(w("widget.recovery", languageCode: widgetLanguageCode)) \(valueText)"
        case .stress:
            return "\(w("widget.stress", languageCode: widgetLanguageCode)) \(valueText)"
        }
    }

    private var smallSecondaryLine: String {
        switch signal {
        case .recovery:
            return "\(w("widget.load", languageCode: widgetLanguageCode)) \(entry.snapshot.stressValue.map(String.init) ?? "--")"
        case .stress:
            return "\(w("widget.rec_short", languageCode: widgetLanguageCode)) \(entry.snapshot.recoveryValue.map(String.init) ?? "--")"
        }
    }
}

struct NervioRecoveryWidget: Widget {
    let kind = "nervio_recovery_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioWidgetProvider()) { entry in
            NervioSignalWidgetView(entry: entry, signal: .recovery)
        }
        .configurationDisplayName(WidgetL10n.string("widget.config.recovery.title", languageCode: Locale.current.language.languageCode?.identifier ?? "en"))
        .description(WidgetL10n.string("widget.config.recovery.desc", languageCode: Locale.current.language.languageCode?.identifier ?? "en"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct NervioStressWidget: Widget {
    let kind = "nervio_stress_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NervioWidgetProvider()) { entry in
            NervioSignalWidgetView(entry: entry, signal: .stress)
        }
        .configurationDisplayName(WidgetL10n.string("widget.config.stress.title", languageCode: Locale.current.language.languageCode?.identifier ?? "en"))
        .description(WidgetL10n.string("widget.config.stress.desc", languageCode: Locale.current.language.languageCode?.identifier ?? "en"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    NervioRecoveryWidget()
} timeline: {
    NervioWidgetEntry(date: .now, snapshot: .preview)
}
