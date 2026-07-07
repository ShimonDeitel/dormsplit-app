import Foundation

struct Expense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var description: String
    var amount: Double
    var payer: String

    init(id: UUID = UUID(), createdAt: Date = Date(), description: String, amount: Double, payer: String) {
        self.id = id
        self.createdAt = createdAt
        self.description = description
        self.amount = amount
        self.payer = payer
    }
}
