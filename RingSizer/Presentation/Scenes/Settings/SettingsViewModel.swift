import RxCocoa
import RxSwift

protocol SettingsViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var refreshTrigger: AnyObserver<Void> { get }
    var closeTrigger: AnyObserver<Void> { get }
    var selectTrigger: AnyObserver<IndexPath> { get }

    var settings: Driver<[SettingsModel]> { get }
}

final class SettingsViewModelImpl: SettingsViewModel {
    private let router: SettingsRouter
    private let userDefaultsStore: UserDefaultsStore

    private enum Constants {
        enum Email {
            static let owner = "pregvanngl@gmail.com"
            static let subject = "Your topic"
            static let body = "Write your question, please."
        }
    }

    private let didLoadSubject = PublishSubject<Void>()
    private(set) lazy var didLoadTrigger: AnyObserver<Void> = {
        didLoadSubject
            .bind(to: refreshTrigger)
            .disposed(by: disposeBag)
        return didLoadSubject.asObserver()
    }()
    
    private let refreshSubject = PublishSubject<Void>()
    private(set) lazy var refreshTrigger: AnyObserver<Void> = {
        refreshSubject
            .compactMap { [weak self] _ in
//                var settingModels = self?.defaultItems()
//                if let dataModel = self?.apphudService.dataModel {
//                    if !isSubscriptionActive && dataModel.isGetPremiumEnabled {
//                        let goPremiumItem = SettingsModel(image: UIImage(named: "goPremium"), title: "Go premium", itemType: .subscriptions)
//                        settingModels?.insert(goPremiumItem, at: 0)
//                    }
//                }
                return self?.defaultItems()
            }
            .bind(to: settingsSubject)
            .disposed(by: disposeBag)
        return refreshSubject.asObserver()
    }()

    private let settingsSubject = BehaviorSubject<[SettingsModel]>(value: [])
    private(set) lazy var settings: Driver<[SettingsModel]> = {
        return settingsSubject.asDriver(onErrorJustReturn: [])
    }()

    private let closeSubject = PublishSubject<Void>()
    private(set) lazy var closeTrigger: AnyObserver<Void> = {
        closeSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.router.dismiss()
            })
            .disposed(by: disposeBag)
        return closeSubject.asObserver()
    }()

    private let selectSubject = PublishSubject<IndexPath>()
    private(set) lazy var selectTrigger: AnyObserver<IndexPath> = {
//        selectSubject
//            .withLatestFrom(settings) { ($0, $1) }
//            .compactMap { indexPath, items -> SettingsModel? in
//                guard items.indices.contains(indexPath.row) else {
//                    return nil
//                }
//                return items[indexPath.row]
//            }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] item in
//                switch item.itemType {
//                case .subscriptions:
//                    self?.router.showPremium()
//                case .support:
//                    let ownerEmail = Constants.Email.owner
//                    let subject = Constants.Email.subject
//                    let body = Constants.Email.body
//                    let emailUrl = self?.createEmailUrl(to: ownerEmail, subject: subject, body: body)
//                    self?.router.showContactUsScreen(applicationSupportEmail: ownerEmail, subject: subject, body: body, emailURL: emailUrl)
//                case .privacyPolicy:
//                    self?.router.showSafari(with: AppConstants.Links.privacyAndPolicy)
//                case .termsOfUse:
//                    self?.router.showSafari(with: AppConstants.Links.termsOfUse)
//                case .rateThisApp:
//                    self?.router.showReviewView()
//                case .share:
//                    self?.router.showShareWithFriends(applicationLink: AppConstants.Links.application)
//                }
//            })
//            .disposed(by: disposeBag)
        return selectSubject.asObserver()
    }()

    private let disposeBag = DisposeBag()

    init(
        router: SettingsRouter,
        userDefaultsStore: UserDefaultsStore
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
    }
}

private extension SettingsViewModelImpl {
    
    func defaultItems() -> [SettingsModel] {
        [SettingsModel(image: UIImage(named: "goPremium"), title: "Support", itemType: .support),
         SettingsModel(image: UIImage(named: "feedback.icon"), title: "Feedback", itemType: .support),
         SettingsModel(image: UIImage(named: "privacyPolicy"), title: "Privacy & Policy", itemType: .privacyPolicy),
         SettingsModel(image: UIImage(named: "termsOfUse"), title: "Terms of Use", itemType: .termsOfUse),
         SettingsModel(image: UIImage(named: "rateApp"), title: "Rate this APP", itemType: .rateThisApp),
         SettingsModel(image: UIImage(named: "share"), title: "Share", itemType: .share)]
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
}
