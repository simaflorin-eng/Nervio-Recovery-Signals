import SwiftUI

struct PrivacySettingsView: View {
    let permissionState: HealthPermissionState
    let onRequestAccess: () async -> Void
    let onResetOnboarding: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.string("Privacy")) {
                    SettingsRow(icon: "iphone", title: "On-device only", detail: "Health data is read locally on this iPhone.")
                    SettingsRow(icon: "icloud.slash", title: "No cloud backend", detail: "Nervio does not use accounts, Firebase, Supabase, analytics SDKs, or external API calls.")
                    SettingsRow(icon: "square.and.pencil", title: "Read-only", detail: "Nervio does not write data to Apple Health.")
                }

                Section(L10n.string("Apple Health")) {
                    HStack {
                        Label(L10n.string("Permission"), systemImage: "heart.text.square")
                        Spacer()
                        Text(permissionLabel)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        Task { await onRequestAccess() }
                    } label: {
                        Label(L10n.string("Request Health Access"), systemImage: "heart.fill")
                    }
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
    let title: LocalizedStringKey
    let detail: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.teal)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    PrivacySettingsView(permissionState: .authorized, onRequestAccess: { }, onResetOnboarding: { })
}
