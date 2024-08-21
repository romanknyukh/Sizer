import RxSwift

protocol HistoryRecordRepository {
    var refreshTrigger: AnyObserver<Void> { get }
    var historyRecords: Observable<[HistoryRecord]> { get }

    func store(historyRecord: HistoryRecord)
    func delete(historyRecord: HistoryRecord)
    func deleteAll()
}

final class HistoryRecordRepositoryImpl: HistoryRecordRepository {
    private let storage: HistoryRecordStorage

    private let refreshSubject = PublishSubject<Void>()
    private(set) lazy var refreshTrigger: AnyObserver<Void> = {
        refreshSubject
            .compactMap { [weak self] in
                return self?.storage.fetchAll()
            }
            .map { [weak self] historyRecordData -> [HistoryRecord] in
                guard let self = self else { return [] }
                return historyRecordData.compactMap { data in
                    return data.toDomain()
                }
            }
            .bind(to: historyRecordsSubject)
            .disposed(by: disposeBag)
        return refreshSubject.asObserver()
    }()

    private let historyRecordsSubject = BehaviorSubject<[HistoryRecord]>(value: [])
    private(set) lazy var historyRecords: Observable<[HistoryRecord]> = {
        return historyRecordsSubject.asObservable()
    }()

    private let disposeBag = DisposeBag()

    init(
        sizersStorage: HistoryRecordStorage
    ) {
        self.storage = sizersStorage
    }

    func store(historyRecord: HistoryRecord) {
        storage.store(historyRecord: .from(sizer: historyRecord))
        refreshTrigger.onNext(())
    }

    func delete(historyRecord: HistoryRecord) {
        storage.delete(historyRecordUid: historyRecord.uid)
        refreshTrigger.onNext(())
    }

    func deleteAll() {
        storage.deleteAll()
        refreshTrigger.onNext(())
    }
}
