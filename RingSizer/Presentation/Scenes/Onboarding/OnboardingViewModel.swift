import RxCocoa
import RxSwift

protocol OnboardingViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var refreshTrigger: AnyObserver<Void> { get }
}

final class OnboardingViewModelImpl: OnboardingViewModel {
    private let router: OnboardingRouter
    private var userDefaultsStore: UserDefaultsStore

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

    private let disposeBag = DisposeBag()

    init(
        router: OnboardingRouter,
        userDefaultsStore: UserDefaultsStore
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
    }
}
