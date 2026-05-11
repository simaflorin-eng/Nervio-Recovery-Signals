import SwiftUI

struct MainTabView: View {
    @ObservedObject var healthKitManager: HealthKitManager
    @ObservedObject var appModel: NervioAppModel
    let onRefresh: () async -> Void
    let onResetOnboarding: () -> Void

    var body: some View {
        TabView {
            DashboardView(
                dashboardState: appModel.dashboardState,
                permissionState: healthKitManager.permissionState,
                isLoading: appModel.isLoading,
                errorMessage: appModel.errorMessage,
                onRefresh: onRefresh
            )
            .tabItem {
                Label("Today", systemImage: "gauge.with.dots.needle.67percent")
            }

            TrendsView(dashboardState: appModel.dashboardState)
                .tabItem {
                    Label("Trends", systemImage: "chart.xyaxis.line")
                }

            PrivacySettingsView(
                permissionState: healthKitManager.permissionState,
                onRequestAccess: {
                    await healthKitManager.requestReadAuthorization()
                    await onRefresh()
                },
                onResetOnboarding: onResetOnboarding
            )
            .tabItem {
                Label("Privacy", systemImage: "lock.shield")
            }
        }
    }
}

#Preview {
    MainTabView(
        healthKitManager: HealthKitManager(),
        appModel: NervioAppModel(),
        onRefresh: { },
        onResetOnboarding: { }
    )
}
