//
//  NervioWatch_ComplicationsControl.swift
//  NervioWatch Complications
//
//  Created by Florin Sima on 12/05/2026.
//

import AppIntents
import SwiftUI
import WidgetKit

@available(watchOS 26.0, *)
struct NervioWatch_ComplicationsControl: ControlWidget {
    static let kind: String = "com.florinsima.Nervio---Recovery-Signals.watchkitapp.NervioWatch Complications"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
    }
}

@available(watchOS 26.0, *)
extension NervioWatch_ComplicationsControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            NervioWatch_ComplicationsControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return NervioWatch_ComplicationsControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

@available(watchOS 26.0, *)
struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

@available(watchOS 26.0, *)
struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}
