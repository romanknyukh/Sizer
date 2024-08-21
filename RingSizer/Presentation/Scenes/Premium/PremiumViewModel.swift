import RxCocoa
import RxSwift

protocol PremiumViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var refreshTrigger: AnyObserver<Void> { get }
    var backTrigger: AnyObserver<Void> { get }
    var selectTrigger: AnyObserver<IndexPath> { get }
    
    var subscriptions: Driver<[SubscriptionModel]> { get }
}

final class PremiumViewModelImpl: PremiumViewModel {
    private let router: PremiumRouter
    private let userDefaultsStore: UserDefaultsStore

    private let didLoadSubject = PublishSubject<Void>()
    private(set) lazy var didLoadTrigger: AnyObserver<Void> = {
        didLoadSubject
            .bind(to: refreshTrigger)
            .disposed(by: disposeBag)
        return didLoadSubject.asObserver()
    }()

    private let refreshSubject = PublishSubject<Void>()
    private(set) lazy var refreshTrigger: AnyObserver<Void> = {
        return refreshSubject.asObserver()
    }()

    private let subscriptionsSubject = BehaviorSubject<[SubscriptionModel]>(value: [])
    private(set) lazy var subscriptions: Driver<[SubscriptionModel]> = {
        return subscriptionsSubject.asDriver(onErrorJustReturn: [])
    }()

    private let backSubject = PublishSubject<Void>()
    private(set) lazy var backTrigger: AnyObserver<Void> = {
        backSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.router.dismiss()
            })
            .disposed(by: disposeBag)
        return backSubject.asObserver()
    }()

    private let selectSubject = PublishSubject<IndexPath>()
    private(set) lazy var selectTrigger: AnyObserver<IndexPath> = {
//        selectSubject
//            .withLatestFrom(subscriptions) { ($0, $1) }
//            .compactMap { indexPath, items -> SubscriptionModel? in
//                guard items.indices.contains(indexPath.row) else {
//                    return nil
//                }
//                return items[indexPath.row]
//            }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] item in
//                let product = switch item.type {
//                case .trial:
//                    self?.apphudService.trialWeekProduct
//                case .weekly:
//                    self?.apphudService.weekProduct
//                case .monthly:
//                    self?.apphudService.monthProduct
//                }
//
//                if let resultProduct = product {
//                    Task { [weak self] in
//                        await self?.apphudService.purchase(product: resultProduct, completion: { isSuccess in
//                            print("purchase is \(isSuccess)")
//                        })
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
        return selectSubject.asObserver()
    }()

    private let disposeBag = DisposeBag()

    init(router: PremiumRouter,
         userDefaultsStore: UserDefaultsStore
//         apphudService: ApphudService
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
//        self.apphudService = apphudService
    }
}

private extension PremiumViewModelImpl {

    func subscriptionItems(isTrialUnused: Bool) -> [SubscriptionModel] {
//        var items = [
//            SubscriptionModel(image: UIImage(named: "premium"), title: "Trial 3-day/Total \(apphudService.trialPrice)", type: .trial),
//            SubscriptionModel(image: UIImage(named: "premium"), title: "Weekly/Total \(apphudService.weekPrice)", type: .weekly),
//            SubscriptionModel(image: UIImage(named: "premium"), title: "Monthly/Total \(apphudService.monthPrice)", type: .monthly)
//        ]
//        if !isTrialUnused { items.remove(at: 0) }
//        return items
        return []
    }
}
