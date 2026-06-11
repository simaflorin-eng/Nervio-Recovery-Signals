import ActivityKit
import Foundation

struct NervioActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let recoveryValue: Int?
        let stressValue: Int?
        let summary: String
        let updatedAt: Date
    }
}
