//
//  AppIntent.swift
//  nervio.widget
//
//  Created by Florin Sima on 12/05/2026.
//

import WidgetKit
import AppIntents

enum NervioWidgetSignal: String, AppEnum {
    case recovery
    case stress

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Signal"
    }

    static var caseDisplayRepresentations: [NervioWidgetSignal: DisplayRepresentation] {
        [
            .recovery: "Recovery",
            .stress: "Stress / Load"
        ]
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Nervio Widget" }
    static var description: IntentDescription { "Choose which Nervio signal appears on the widget." }
    static var parameterSummary: some ParameterSummary {
        Summary("Show \(\.$signal)")
    }

    @Parameter(title: "Signal", default: .recovery)
    var signal: NervioWidgetSignal
}
