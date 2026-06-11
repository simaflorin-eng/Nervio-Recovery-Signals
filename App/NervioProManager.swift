import StoreKit
import Observation

@Observable
@MainActor
final class NervioProManager {
    static let shared = NervioProManager()

    private(set) var isPro: Bool = false
    private(set) var product: Product? = nil
    private(set) var purchaseError: String? = nil
    var isLoading: Bool = false

    var displayPrice: String {
        product?.displayPrice ?? "$3.99"
    }

    private let productID = "com.florinsima.nervio.pro"
    private let appGroupID = "group.com.florinsima.Nervio-Recovery-Signals"
    private let proKey = "nervio.isPro"

    private init() {
        Task {
            await loadEntitlements()
            await loadProduct()
        }
        Task {
            for await result in Transaction.updates {
                if case .verified(let tx) = result, tx.productID == productID {
                    isPro = true
                    syncToAppGroup()
                    await tx.finish()
                }
            }
        }
    }

    func purchase() async {
        guard let product, !isLoading else { return }
        isLoading = true
        purchaseError = nil
        defer { isLoading = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let tx) = verification {
                    isPro = true
                    syncToAppGroup()
                    await tx.finish()
                } else {
                    purchaseError = "Purchase could not be verified."
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func restore() async {
        isLoading = true
        purchaseError = nil
        defer { isLoading = false }
        do {
            try await AppStore.sync()
            await loadEntitlements()
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func syncToAppGroup() {
        UserDefaults(suiteName: appGroupID)?.set(isPro, forKey: proKey)
    }

    private func loadEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result,
               tx.productID == productID,
               tx.revocationDate == nil {
                isPro = true
                syncToAppGroup()
                return
            }
        }
    }

    private func loadProduct() async {
        guard let products = try? await Product.products(for: [productID]) else { return }
        product = products.first
    }
}
