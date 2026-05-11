import SwiftUI

struct PrivacySettingsView: View {
    let permissionState: HealthPermissionState
    let onRequestAccess: () async -> Void
    let onResetOnboarding: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Privacy") {
                    SettingsRow(icon: "iphone", title: "On-device only", detail: "Health data is read locally on this iPhone.")
                    SettingsRow(icon: "icloud.slash", title: "No cloud backend", detail: "Nervio does not use accounts, Firebase, Supabase, analytics SDKs, or external API calls.")
                    SettingsRow(icon: "square.and.pencil", title: "Read-only", detail: "Nervio does not write data to Apple Health.")
                }

                Section("Apple Health") {
                    HStack {
                        Label("Permission", systemImage: "heart.text.square")
                        Spacer()
                        Text(permissionLabel)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        Task { await onRequestAccess() }
                    } label: {
                        Label("Request Health Access", systemImage: "heart.fill")
                    }
                }

                Section("Onboarding") {
                    Button("Show Onboarding Again", action: onResetOnboarding)
                }

                Section {
                    Text("Nervio estimates wellness-oriented recovery signals from available Apple Health data. It does not diagnose stress, burnout, illness, or any medical condition.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Privacy")
        }
    }

    private var permissionLabel: String {
        switch permissionState {
        case .notDetermined: "Not requested"
        case .unavailable: "Unavailable"
        case .requesting: "Requesting"
        case .authorized: "Requested"
        case .denied: "Needs review"
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
