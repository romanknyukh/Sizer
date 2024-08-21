import RxCocoa
import RxSwift

protocol NameAlertViewModel {
    var cancelTrigger: AnyObserver<Void> { get }
    var saveTrigger: AnyObserver<Void> { get }
    var nameInputText: AnyObserver<String?> { get }
    var isSaveButtonEnabled: Driver<Bool> { get }
}

final class NameAlertViewModelImpl: NameAlertViewModel {
    private let router: NameAlertRouter
    private let historyRecordRepository: HistoryRecordRepository
    private let historyRecord: HistoryRecord

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

    private let saveSubject = PublishSubject<Void>()
    private(set) lazy var saveTrigger: AnyObserver<Void> = {
        saveSubject
            .observe(on: MainScheduler.instance)
            .withLatestFrom(nameInputTextSubject) { $1 }
            .compactMap { $0 }
            .compactMap { [weak self] inputName in
                guard let self else { return self?.historyRecord }
                return HistoryRecord(
                    uid: self.historyRecord.uid,
                    name: inputName,
                    date: self.historyRecord.date,
                    size: self.historyRecord.size,
                    type: self.historyRecord.type
                )
            }
            .subscribe(onNext: { [weak self] historyRecord in
                self?.router.finish {
                    self?.historyRecordRepository.store(historyRecord: historyRecord)
                }
            })
            .disposed(by: disposeBag)
        return saveSubject.asObserver()
    }()

    private let nameInputTextSubject = BehaviorSubject<String?>(value: nil)
    private(set) lazy var nameInputText: AnyObserver<String?> = {
        return nameInputTextSubject.asObserver()
    }()

    private let isSaveButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
    private(set) lazy var isSaveButtonEnabled: Driver<Bool> = {
        Observable.combineLatest(nameInputTextSubject, BehaviorSubject<String?>(value: nil))
            .compactMap { $0.0 }
            .map { inputText in
                !inputText.isEmpty
            }
            .bind(to: isSaveButtonEnabledSubject)
            .disposed(by: disposeBag)
        return isSaveButtonEnabledSubject.asDriver(onErrorJustReturn: false)
    }()

    private let disposeBag = DisposeBag()

    init(
        router: NameAlertRouter,
        historyRecordRepository: HistoryRecordRepository,
        historyRecord: HistoryRecord
    ) {
        self.router = router
        self.historyRecord = historyRecord
        self.historyRecordRepository = historyRecordRepository
    }
}
