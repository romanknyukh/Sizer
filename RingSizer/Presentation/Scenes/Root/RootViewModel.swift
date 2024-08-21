import RxCocoa
import RxSwift

protocol RootViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
}

final class RootViewModelImpl: RootViewModel {
    private let router: RootRouter
    private let userDefaultsStore: UserDefaultsStore

    private let didLoadSubject = PublishSubject<Void>()
    private(set) lazy var didLoadTrigger: AnyObserver<Void> = {
        didLoadSubject
            .subscribe(onNext: { [weak self] in
                guard let self else {
                    return
                }
//                self.userDefaultsStore.isOnboardingFinished ?
                self.router.showMainScreen()
//                : self.router.showOnboarding()
            })
            .disposed(by: disposeBag)
        return didLoadSubject.asObserver()
    }()

    private let disposeBag = DisposeBag()

    init(
        router: RootRouter,
        userDefaultsStore: UserDefaultsStore
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
    }
}
