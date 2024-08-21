import Foundation

struct HistoryRecord {
    let uid: String
    let name: String
    let date: Date
    let size: String
    let type: SizerType

    init(
        uid: String = UUID().uuidString,
        name: String,
        date: Date,
        size: String,
        type: SizerType
    ) {
        self.uid = uid
        self.name = name
        self.date = date
        self.size = size
        self.type = type
    }
}
