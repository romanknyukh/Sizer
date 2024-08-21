import RxCocoa
import RxSwift

protocol SavedViewModel: AnyObject {
    var didLoadTrigger: AnyObserver<Void> { get }
    var willAppearTrigger: AnyObserver<Void> { get }
    var editTrigger: AnyObserver<IndexPath> { get }
    var deleteTrigger: AnyObserver<IndexPath> { get }
    var deleteAllTrigger: AnyObserver<Void> { get }

    var historyRecords: Driver<[HistoryRecord]> { get }
}

final class SavedViewModelImpl: SavedViewModel {
    private let router: SavedRouter
    private let userDefaultsStore: UserDefaultsStore
    private let historyRecordRepository: HistoryRecordRepository

    private let didLoadSubject = PublishSubject<Void>()
    private(set) lazy var didLoadTrigger: AnyObserver<Void> = {
        return didLoadSubject.asObserver()
    }()

    private let willAppearSubject = PublishSubject<Void>()
    private(set) lazy var willAppearTrigger: AnyObserver<Void> = {
        willAppearSubject
            .bind(to: refreshTrigger)
            .disposed(by: disposeBag)
        return willAppearSubject.asObserver()
    }()

    private let refreshSubject = PublishSubject<Void>()
    private(set) lazy var refreshTrigger: AnyObserver<Void> = {
        refreshSubject
            .bind(to: historyRecordRepository.refreshTrigger)
            .disposed(by: disposeBag)
        return refreshSubject.asObserver()
    }()

    private let historyRecordsSubject = BehaviorSubject<[HistoryRecord]>(value: [])
    private(set) lazy var historyRecords: Driver<[HistoryRecord]> = {
        historyRecordRepository.historyRecords
            .bind(to: historyRecordsSubject)
            .disposed(by: disposeBag)
        return historyRecordsSubject.asDriver(onErrorJustReturn: [])
    }()

    private let deleteSubject = PublishSubject<IndexPath>()
    private(set) lazy var deleteTrigger: AnyObserver<IndexPath> = {
        deleteSubject
            .flatMap { [weak self] indexPath -> Single<(SimpleFlowResult, IndexPath)> in
                self?.router.showDeleteAlert(with: .historyRecord)
                    .map { [indexPath] in ($0, indexPath) } ?? .never()
            }
            .filter { result, _ in
                guard case .finished = result else { return false }
                return true
            }
            .withLatestFrom(historyRecords) { ($0.1, $1) }
            .compactMap { indexPath, historyRecords -> HistoryRecord? in
                guard historyRecords.indices.contains(indexPath.row) else { return nil }
                return historyRecords[indexPath.row]
            }
            .subscribe(onNext: { [weak self] historyRecord in
                self?.historyRecordRepository.delete(historyRecord: historyRecord)
            })
            .disposed(by: disposeBag)
        return deleteSubject.asObserver()
    }()

    private let deleteAllSubject = PublishSubject<Void>()
    private(set) lazy var deleteAllTrigger: AnyObserver<Void> = {
        deleteAllSubject
            .flatMap({ [weak self] _ -> Single<SimpleFlowResult> in
                self?.router.showDeleteAlert(with: .allHistory)
                    .map { $0 } ?? .never()
            })
            .filter { flowResult in
                guard case .finished = flowResult else { return false }
                return true
            }
            .subscribe(onNext: { [weak self] _ in
                self?.historyRecordRepository.deleteAll()
            })
            .disposed(by: disposeBag)
        return deleteAllSubject.asObserver()
    }()

    private let editSubject = PublishSubject<IndexPath>()
    private(set) lazy var editTrigger: AnyObserver<IndexPath> = {
        editSubject
            .withLatestFrom(historyRecords) { ($0, $1) }
            .compactMap { indexPath, historyRecords -> HistoryRecord? in
                guard historyRecords.indices.contains(indexPath.row) else { return nil }
                return historyRecords[indexPath.row]
            }
            .subscribe(onNext: { [weak self] historyRecord in
                self?.router.showNameAlert(for: historyRecord)
            })
            .disposed(by: disposeBag)

        return editSubject.asObserver()
    }()

    private let disposeBag = DisposeBag()

    init(
        router: SavedRouter,
        userDefaultsStore: UserDefaultsStore,
        sizersRepository: HistoryRecordRepository
    ) {
        self.router = router
        self.userDefaultsStore = userDefaultsStore
        self.historyRecordRepository = sizersRepository
    }
}
