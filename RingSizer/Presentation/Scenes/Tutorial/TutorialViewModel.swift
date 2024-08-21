import RxCocoa
import RxSwift

protocol TutorialViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var backTrigger: AnyObserver<Void> { get }
    var nextTrigger: AnyObserver<IndexPath> { get }

    var steps: Driver<[TutorialStep]> { get }
    var pagesNumber: Driver<Int> { get }
    var currentPage: Driver<Int> { get }
}

final class TutorialViewModelImpl: TutorialViewModel {
    private let router: TutorialRouter
    private let tutorialType: SizerType

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
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let tutorialItems = self.tutorialSteps(for: self.tutorialType)
                self.stepsSubject.onNext(tutorialItems)
                self.pagesNumberSubject.onNext(tutorialItems.count)

            })
            .disposed(by: disposeBag)

        return refreshSubject.asObserver()
    }()

    private let backSubject = PublishSubject<Void>()
    private(set) lazy var backTrigger: AnyObserver<Void> = {
        backSubject
            .subscribe(onNext: { [weak self] _ in
                self?.router.cancel()
            })
            .disposed(by: disposeBag)
        return backSubject.asObserver()
    }()

    private let nextSubject = PublishSubject<IndexPath>()
    private(set) lazy var nextTrigger: AnyObserver<IndexPath> = {
        nextSubject
            .observe(on: MainScheduler.instance)
            .withLatestFrom(steps) { ($0, $1) }
            .subscribe(onNext: { [weak self] (indexPath, steps) in
                if steps.indices.contains(indexPath.row + 1) {
                    self?.currentPageSubject.onNext(indexPath.row + 1)
                } else {
                    self?.router.cancel()
                }
            })
            .disposed(by: disposeBag)
        return nextSubject.asObserver()
    }()

    private let stepsSubject = BehaviorSubject<[TutorialStep]>(value: [])
    private(set) lazy var steps: Driver<[TutorialStep]> = {
        return stepsSubject.asDriver(onErrorJustReturn: [])
    }()

    private let currentPageSubject = BehaviorSubject<Int>(value: 0)
    private(set) lazy var currentPage: Driver<Int> = {
        return currentPageSubject.asDriver(onErrorJustReturn: 0)
    }()

    private let pagesNumberSubject = BehaviorSubject(value: 0)
    private(set) lazy var pagesNumber: Driver<Int> = {
        return pagesNumberSubject.asDriver(onErrorJustReturn: 0)
    }()

    private let disposeBag = DisposeBag()

    init(
        router: TutorialRouter,
        sizerType: SizerType
    ) {
        self.router = router
        self.tutorialType = sizerType
    }
}

private extension TutorialViewModelImpl {
    func tutorialSteps(for type: SizerType) -> [TutorialStep] {
        switch type {
        case .finger:
            return [
                TutorialStep(
                    image: UIImage(named: "finger.tutorial.icon.1"),
                    description: "Place the finger on the screen to determine the size"
                ),
                TutorialStep(
                    image: UIImage(named: "finger.tutorial.icon.2"),
                    description: "Use the slider to align the edges of your finger with the finger on screen"
                ),
                TutorialStep(
                    image: UIImage(named: "finger.tutorial.icon.3"),
                    description: "The screen will show the correct ring size"
                )
            ]
        case .ring:
            return [
                TutorialStep(
                    image: UIImage(named: "ring.tutorial.icon.1"),
                    description: "Place the ring on the cirlce to determine the size"
                ),
                TutorialStep(
                    image: UIImage(named: "ring.tutorial.icon.2"),
                    description: "Use the slider to align the edges of the circle with the inner of the ring"
                ),
                TutorialStep(
                    image: UIImage(named: "ring.tutorial.icon.3"),
                    description: "The screen will show the correct ring size"
                )
            ]
        }
    }
}
