import UIKit.UIImage

enum SubscriptionType {
    case trial
    case weekly
    case monthly
}

struct SubscriptionModel {
    let image: UIImage?
    let title: String
    let type: SubscriptionType
}
