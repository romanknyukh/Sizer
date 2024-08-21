protocol HistoryRecordStorage {
    func store(historyRecord: HistoryRecordData)
    func delete(historyRecordUid: String)
    func deleteAll()
    func fetchAll() -> [HistoryRecordData]
}

final class HistoryRecordStorageImpl: HistoryRecordStorage {
    private let realmStorage: RealmStorage<HistoryRecordData>

    init(realmStorage: RealmStorage<HistoryRecordData> = .init(config: .sizers)) {
        self.realmStorage = realmStorage
    }

    func store(historyRecord: HistoryRecordData) {
        if realmStorage.fetch(uid: historyRecord.uid) == nil {
            realmStorage.store(value: historyRecord)
        } else {
            realmStorage.update(uid: historyRecord.uid, updateClosure: { storedData in
                storedData.name = historyRecord.name
            })
        }
    }

    func delete(historyRecordUid: String) {
        realmStorage.delete(uid: historyRecordUid)
    }

    func deleteAll() {
        realmStorage.deleteAll()
    }

    func fetchAll() -> [HistoryRecordData] {
        realmStorage.fetchAll()
    }
}
