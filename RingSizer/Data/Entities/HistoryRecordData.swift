import RealmSwift

class HistoryRecordData: Object, Persistable {
    @Persisted(primaryKey: true) var uid: String
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted var size: String
    @Persisted var type: String

    convenience init(
        uid: String,
        name: String,
        date: Date,
        size: String,
        type: String
    ) {
        self.init()

        self.uid = uid
        self.name = name
        self.date = date
        self.size = size
        self.type = type
    }

    func toDomain() -> HistoryRecord {
        return .init(
            uid: uid,
            name: name,
            date: date,
            size: size,
            type: SizerType(rawValue: type) ?? .finger
        )
    }

    static func from(sizer: HistoryRecord) -> HistoryRecordData {
        return .init(
            uid: sizer.uid,
            name: sizer.name,
            date: sizer.date,
            size: sizer.size,
            type: sizer.type.rawValue
        )
    }
}
