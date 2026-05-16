import Foundation

enum AppStoreReviewLink {
    // Replace with your real App Store numeric app ID.
    static let appID = "6768915068"

    static var writeReviewURL: URL? {
        URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")
    }
}
