import Foundation
import GRDB

struct ClipboardItem: Identifiable, Equatable, Hashable {
    var id: Int64?
    var content: String
    var contentType: String
    var preview: String
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date
    var hash: String

    init(
        id: Int64? = nil,
        content: String,
        contentType: String = "text",
        isPinned: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.contentType = contentType
        self.preview = content.trimmedPreview
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.hash = content.sha256Hash
    }
}

// MARK: - GRDB Codable Record

extension ClipboardItem: Codable, FetchableRecord, MutablePersistableRecord {
    static let databaseTableName = "clipboardItems"

    enum Columns: String, ColumnExpression {
        case id, content, contentType, preview, isPinned, createdAt, updatedAt, hash
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
