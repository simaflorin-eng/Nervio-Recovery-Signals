import SwiftUI
import StoreKit

struct ProPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    private var pro: NervioProManager { NervioProManager.shared }

    var body: some View {
        ZStack {
            NervioBackground(tint: .green)

            VStack(spacing: 0) {
                closeButton

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroSection
                        featuresSection
                    }
                }

                purchaseSection
            }
        }
        .onChange(of: pro.isPro) {
            if pro.isPro { dismiss() }
        }
    }

    // MARK: - Header

    private var closeButton: some View {
        HStack {
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [.green.opacity(0.30), .clear], center: .center, startRadius: 0, endRadius: 60))
                    .frame(width: 110, height: 110)
                Image(systemName: "sparkles")
                    .font(.system(size: 46))
                    .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            Text("Nervio Pro")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(L10n.string("Full recovery intelligence"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(spacing: 10) {
            featureRow(
                icon: "square.grid.2x2.fill",
                title: L10n.string("Home Screen Widgets"),
                description: L10n.string("Live recovery and stress scores on your Home Screen and Lock Screen.")
            )
            featureRow(
                icon: "circle.dotted.and.circle",
                title: L10n.string("Live Activity"),
                description: L10n.string("Recovery score in Dynamic Island and on your Lock Screen throughout the day.")
            )
            featureRow(
                icon: "sparkles",
                title: L10n.string("All Future Pro Features"),
                description: L10n.string("Every new Pro feature we ship, included at no extra cost.")
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 28, alignment: .center)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.subheadline)
        }
        .padding(14)
        .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Purchase

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            if let error = pro.purchaseError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button {
                Task { await pro.purchase() }
            } label: {
                ZStack {
                    if pro.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        VStack(spacing: 3) {
                            Text(L10n.string("Unlock Nervio Pro"))
                                .font(.headline)
                            Text(pro.product.map { "\($0.displayPrice) · \(L10n.string("One-time purchase"))" } ?? "$3.99 · \(L10n.string("One-time purchase"))")
                                .font(.caption)
                                .opacity(0.82)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(pro.isLoading)

            Button { Task { await pro.restore() } } label: {
                Text(L10n.string("Restore Purchase"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .disabled(pro.isLoading)

            HStack(spacing: 20) {
                Link(L10n.string("Terms"), destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                Link(L10n.string("Privacy"), destination: URL(string: "https://nervio.app/privacy")!)
            }
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }
        .padding(20)
    }
}
