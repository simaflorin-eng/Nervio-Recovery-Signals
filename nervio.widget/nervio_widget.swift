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

    private var isPro: Bool {
        UserDefaults(suiteName: "group.com.florinsima.Nervio-Recovery-Signals")?.bool(forKey: "nervio.isPro") ?? false
    }

    var body: some View {
        if !isPro {
            proGateBody
        } else {
            switch family {
            case .systemSmall:  smallBody
            case .systemLarge:  largeBody
            default:            mediumBody
            }
        }
    }

    private var proGateBody: some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
            Text("Nervio Pro")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("Unlock in app")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.06, blue: 0.11), Color(red: 0.07, green: 0.10, blue: 0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    // MARK: - Layouts

    private var smallBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            signalLabel
            Spacer(minLength: 10)
            ring
                .frame(width: 76, height: 76)
                .frame(maxWidth: .infinity)
            Spacer(minLength: 10)
            Text(localizedSummary)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.72))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .containerBackground(for: .widget) { widgetBackground }
    }

    private var mediumBody: some View {
        HStack(spacing: 16) {
            ring
                .frame(width: 84, height: 84)

            VStack(alignment: .leading, spacing: 4) {
                signalLabel
                Text(scoreHeadline)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Text(localizedSummary)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.62))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 4)
                HStack(spacing: 12) {
                    Label(entry.snapshot.steps.value, systemImage: "figure.walk")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.55))
                        .lineLimit(1)
                    Label(entry.snapshot.hrv.value, systemImage: "waveform.path.ecg")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.55))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .containerBackground(for: .widget) { widgetBackground }
    }

    private var largeBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                signalLabel
                Spacer()
                Text("\(w("widget.updated", languageCode: widgetLanguageCode)) \(entry.snapshot.updatedAt, style: .time)")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.38))
            }

            Spacer(minLength: 12)

            HStack(alignment: .top, spacing: 14) {
                ring
                    .frame(width: 100, height: 100)

                VStack(alignment: .leading, spacing: 5) {
                    Text(scoreHeadline)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(localizedSummary)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.62))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 14)

            HStack(spacing: 8) {
                metricChip(title: entry.snapshot.hrv.title, value: entry.snapshot.hrv.value, symbol: entry.snapshot.hrv.symbolName)
                metricChip(title: entry.snapshot.restingHeartRate.title, value: entry.snapshot.restingHeartRate.value, symbol: entry.snapshot.restingHeartRate.symbolName)
                metricChip(title: entry.snapshot.steps.title, value: entry.snapshot.steps.value, symbol: entry.snapshot.steps.symbolName)
            }

            Spacer(minLength: 10)

            HStack(spacing: 6) {
                Image(systemName: entry.snapshot.sleep.symbolName)
                    .font(.caption2)
                    .foregroundStyle(color.opacity(0.75))
                    .widgetAccentable()
                Text(entry.snapshot.sleep.value)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.55))
                Spacer()
                Text("R \(entry.snapshot.recoveryValue.map(String.init) ?? "--")  ·  S \(entry.snapshot.stressValue.map(String.init) ?? "--")")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(14)
        .containerBackground(for: .widget) { widgetBackground }
    }

    // MARK: - Components

    private var signalLabel: some View {
        Text((signal == .recovery
            ? w("widget.recovery", languageCode: widgetLanguageCode)
            : w("widget.stress", languageCode: widgetLanguageCode)).uppercased())
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .tracking(1.0)
            .widgetAccentable()
    }

    private var ring: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.10), lineWidth: 10)

            // Glow layer
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color.opacity(0.45), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .blur(radius: 6)
                .widgetAccentable()

            // Main arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .widgetAccentable()

            Text(valueText)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
    }

    private func metricChip(title: String, value: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Label(localizedMetricTitle(from: title), systemImage: symbol)
                .font(.caption2.weight(.medium))
                .foregroundStyle(color)
                .lineLimit(1)
                .widgetAccentable()
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    @ViewBuilder
    private var widgetBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.06, blue: 0.11),
                    Color(red: 0.07, green: 0.10, blue: 0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [color.opacity(0.42), .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 200
            )
        }
    }

    // MARK: - Data

    private var score: Int? {
        switch signal {
        case .recovery: return entry.snapshot.recoveryValue
        case .stress:   return entry.snapshot.stressValue
        }
    }

    private var progress: CGFloat { CGFloat(Double(score ?? 0) / 100.0) }
    private var valueText: String { score.map(String.init) ?? "--" }

    private var color: Color {
        switch signal {
        case .recovery: return semanticRecoveryColor(for: score)
        case .stress:   return semanticStressColor(for: score)
        }
    }

    private func semanticRecoveryColor(for value: Int?) -> Color {
        guard let value else { return .teal }
        switch value {
        case 70...100: return .green
        case 52..<70:  return .yellow
        case 35..<52:  return .orange
        default:       return .red
        }
    }

    private func semanticStressColor(for value: Int?) -> Color {
        guard let value else { return .orange }
        switch value {
        case 75...100: return .red
        case 50..<75:  return .orange
        case 25..<50:  return .yellow
        default:       return .green
        }
    }

    private var scoreHeadline: String {
        let label = signal == .recovery
            ? w("widget.recovery_score", languageCode: widgetLanguageCode)
            : w("widget.stress_score", languageCode: widgetLanguageCode)
        return score.map { "\(label) \($0)" } ?? label
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

    private func localizedMetricTitle(from title: String) -> String {
        let n = title.lowercased()
        if n.contains("hrv")     { return "HRV" }
        if n.contains("resting") { return "R-HR" }
        if n.contains("sleep")   { return w("Sleep", languageCode: widgetLanguageCode) }
        if n.contains("step")    { return "Steps" }
        return title
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
