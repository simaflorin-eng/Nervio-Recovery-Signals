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

                    Text("Nervio")
                        .font(.largeTitle.bold())

                    Text("Recovery and nervous system insights based on available Apple Health data.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 14) {
                    OnboardingPoint(icon: "lock.shield", title: "Private by design", detail: "Your health data never leaves your iPhone.")
                    OnboardingPoint(icon: "heart.text.square", title: "Read-only Health access", detail: "Nervio reads HRV, resting heart rate, sleep, activity, workouts, and mindful sessions.")
                    OnboardingPoint(icon: "chart.line.uptrend.xyaxis", title: "Transparent signals", detail: "Scores compare today with your own recent baseline and avoid medical conclusions.")
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        Task { await onContinue() }
                    } label: {
                        Label(isLoading ? "Loading" : "Connect Apple Health", systemImage: "heart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(isLoading || permissionState == .requesting)

                    Button("Use Preview Data", action: onUsePreviewData)
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
            Text("Apple Health is unavailable on this device. Preview data is shown in Simulator.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        case .denied(let message):
            Text("Health access was not granted. \(message)")
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
