import Foundation
import UIKit

class DeepLinkHandler {
    enum DeeplinkType {
        case telephone
        case linkedin
        case twitter

        static func getUrl(from: String, type: DeeplinkType) -> [String: NSURL] {
            switch type {
            case .telephone:
                return ["appURL": NSURL(string: "tel://\(from)")!,
                        "webURL": NSURL(string: "tel://\(from)")!]
            case .linkedin:
                let username = URL(string: from)?.pathComponents[2]
                return ["appURL": NSURL(string: "linkedin://profile/\(username ?? "alisonglima")")!,
                        "webURL": NSURL(string: from)!]
            case .twitter:
                return ["appURL": NSURL(string: "twitter://user?screen_name=\(from)")!,
                        "webURL": NSURL(string: "https://twitter.com/\(from)")!]
            }
        }
    }

    static func openURL(from: String, type: DeeplinkType) {
        let url: [String: NSURL] = DeeplinkType.getUrl(from: from, type: type)

        let application = UIApplication.shared

        if application.canOpenURL(url["appURL"]! as URL) {
               application.open(url["appURL"]! as URL)
          } else {
               application.open(url["webURL"]! as URL)
          }
    }
}
