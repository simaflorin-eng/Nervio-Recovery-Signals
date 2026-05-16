import SwiftUI

struct OnboardingView: View {
    let permissionState: HealthPermissionState
    let isLoading: Bool
    let onContinue: () async -> Void
    let onUsePreviewData: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 28) {
                Spacer(minLength: 24)

                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "waveform.path.ecg.rectangle")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(.teal)

                    Text(L10n.string("Nervio"))
                        .font(.largeTitle.bold())

                    Text(L10n.string("Recovery and nervous system insights based on available Apple Health data."))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 14) {
                    OnboardingPoint(icon: "lock.shield", title: LocalizedStringKey(L10n.string("Private by design")), detail: LocalizedStringKey(L10n.string("Your health data never leaves your iPhone.")))
                    OnboardingPoint(icon: "heart.text.square", title: LocalizedStringKey(L10n.string("Read-only Health access")), detail: LocalizedStringKey(L10n.string("Nervio reads HRV, resting heart rate, sleep, activity, workouts, and mindful sessions.")))
                    OnboardingPoint(icon: "chart.line.uptrend.xyaxis", title: LocalizedStringKey(L10n.string("Transparent signals")), detail: LocalizedStringKey(L10n.string("Scores compare today with your own recent baseline and avoid medical conclusions.")))
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        Task { await onContinue() }
                    } label: {
                        Label(
                            isLoading ? L10n.string("Loading") : L10n.string("Connect Apple Health"),
                            systemImage: "heart.fill"
                        )
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(isLoading || permissionState == .requesting)

                    Button(L10n.string("Use Preview Data"), action: onUsePreviewData)
                        .buttonStyle(.borderless)

                    permissionMessage
                }
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
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
            Text(
                String(
                    format: L10n.string("Health access was not granted. %@"),
                    message
                )
            )
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
    let title: LocalizedStringKey
    let detail: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.teal)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    OnboardingView(permissionState: .notDetermined, isLoading: false) { } onUsePreviewData: { }
}
