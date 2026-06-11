//
//  NervioWatchApp.swift
//  NervioWatch Watch App
//
//  Created by Florin Sima on 12/05/2026.
//

import SwiftUI
import WatchKit
import WidgetKit

@main
struct NervioWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .backgroundTask(.appRefresh("nervio.watch.refresh")) {
            let manager = WatchHealthKitManager()
            if let steps = await manager.fetchTodayAppleWatchSteps() {
                await MainActor.run {
                    WatchStepComplicationCacheStore.save(stepsValue: steps, updatedAt: .now, sourceLabel: "From Watch")
                }
                WidgetCenter.shared.reloadAllTimelines()
            }
            await scheduleNextWatchRefresh()
        }
    }
}

@MainActor
func scheduleNextWatchRefresh() {
    WKApplication.shared().scheduleBackgroundRefresh(
        withPreferredDate: Date().addingTimeInterval(15 * 60),
        userInfo: nil,
        scheduledCompletion: { _ in }
    )
}
