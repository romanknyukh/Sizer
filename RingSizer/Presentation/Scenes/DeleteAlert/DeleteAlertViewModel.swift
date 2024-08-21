import RxCocoa
import RxSwift

enum DeleteAlertType {
    case allHistory
    case historyRecord
}

protocol DeleteAlertViewModel {
    var didLoadTrigger: AnyObserver<Void> { get }

    var cancelTrigger: AnyObserver<Void> { get }
    var confirmTrigger: AnyObserver<Void> { get }
    var alertTitle: Driver<String> { get }
}

final class DeleteAlertViewModelImpl: DeleteAlertViewModel {
    private let router: DeleteAlertRouter
    private let alertType: DeleteAlertType

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
            .map { [weak self] _ in
                guard let self else { return "" }
                return switch self.alertType {
                case .historyRecord: "Are you sure you want to delete this size?"
                case .allHistory: "Are you sure you want to clear all history?"
                }
            }
            .bind(to: alertTitleSubject)
            .disposed(by: disposeBag)
        return refreshSubject.asObserver()
    }()

    private let cancelSubject = PublishSubject<Void>()
    private(set) lazy var cancelTrigger: AnyObserver<Void> = {
        cancelSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.router.cancel()
            })
            .disposed(by: disposeBag)
        return cancelSubject.asObserver()
    }()

    private let confirmSubject = PublishSubject<Void>()
    private(set) lazy var confirmTrigger: AnyObserver<Void> = {
        confirmSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.router.finish()
            })
            .disposed(by: disposeBag)
        return confirmSubject.asObserver()
    }()

    private let alertTitleSubject = BehaviorSubject<String>(value: "")
    private(set) lazy var alertTitle: Driver<String> = {
        return alertTitleSubject.asDriver(onErrorJustReturn: "")
    }()

    private let disposeBag = DisposeBag()

    init(router: DeleteAlertRouter, type: DeleteAlertType) {
        self.router = router
        self.alertType = type
    }
}
