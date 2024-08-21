import RxCocoa
import RxSwift

enum SizerType: String {
    case ring
    case finger
}

protocol MainViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var metricsTrigger: AnyObserver<Void> { get }
    var tutorialTrigger: AnyObserver<Void> { get }
    var saveTrigger: AnyObserver<Void> { get }
    var ringDiameterInMM: AnyObserver<Float> { get }
    var sizerType: AnyObserver<SizerType> { get }

    var metrics: Observable<RingSizeMetric> { get }
    var ringSize: Observable<String> { get }
}

final class MainViewModelImpl: MainViewModel {
    private let router: MainRouter
    private let userDefaultsStore: UserDefaultsStore

    private let didLoadSubject = PublishSubject<Void>()
    private(set) lazy var didLoadTrigger: AnyObserver<Void> = {
        return didLoadSubject.asObserver()
    }()

    private let tutorialSubject = PublishSubject<Void>()
    private(set) lazy var tutorialTrigger: AnyObserver<Void> = {
        tutorialSubject
            .withLatestFrom(sizerTypeSubject)
            .subscribe(onNext: { [weak self] sizerType in
                self?.router.showTutorial(for: sizerType)
            })
            .disposed(by: disposeBag)
        return tutorialSubject.asObserver()
    }()

    private let saveSubject = PublishSubject<Void>()
    private(set) lazy var saveTrigger: AnyObserver<Void> = {
        saveSubject
            .withLatestFrom(sizerTypeSubject)
            .subscribe(onNext: { [weak self] sizerType in
                let historyRecord = HistoryRecord(
                    name: "",
                    date: .now,
                    size: "16 US/CA",
                    type: sizerType
                )

                self?.router.showNameAlert(for: historyRecord)
            })
            .disposed(by: disposeBag)
        return saveSubject.asObserver()
    }()

    private let metricsSubject = PublishSubject<Void>()
    private(set) lazy var metricsTrigger: AnyObserver<Void> = {
        // Add routing
        metricsSubject
            .map { RingSizeMetric.allCases.randomElement() ?? .us }
            .bind(to: currentMetricsSubject)
            .disposed(by: disposeBag)
        return metricsSubject.asObserver()
    }()

    private let ringDiameterInMMSubject = PublishSubject<Float>()
    private(set) lazy var ringDiameterInMM: AnyObserver<Float> = {
        ringDiameterInMMSubject
            .subscribe(onNext: { [weak self] value in
                print(value)
            })
            .disposed(by: disposeBag)
        return ringDiameterInMMSubject.asObserver()
    }()

    private let currentMetricsSubject = BehaviorSubject<RingSizeMetric>(value: .us)
    private(set) lazy var metrics: Observable<RingSizeMetric> = {
        return currentMetricsSubject.asObservable()
    }()

    private(set) lazy var ringSize: Observable<String> = {
        return Observable.combineLatest(currentMetricsSubject, ringDiameterInMMSubject)
            .map { metrics, sizeInMM in
                return metrics.name(from: sizeInMM)
            }
    }()

    private let sizerTypeSubject = BehaviorSubject<SizerType>(value: .ring)
    private(set) lazy var sizerType: AnyObserver<SizerType> = {
        sizerTypeSubject.asObserver()
    }()

    private let disposeBag = DisposeBag()

    init(
        router: MainRouter,
        userDefaultsStore: UserDefaultsStore
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
    }
}
