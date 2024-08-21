import Foundation

protocol UserDefaultsStore {
    var isOnboardingFinished: Bool { get set }
    var hasSubscription: Bool { get }
}

class UserDefaultsStoreImpl: UserDefaultsStore {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    struct Key {
        static let isFirstLaunch = "isFirstLaunch"
        static let hasSubscription = "hasSubscription"
    }

    var isOnboardingFinished: Bool {
        get {
            return userDefaults.bool(forKey: Key.isFirstLaunch)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.isFirstLaunch)
        }
    }

    var hasSubscription: Bool {
        get {
            return userDefaults.bool(forKey: Key.hasSubscription)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.hasSubscription)
        }
    }
}
