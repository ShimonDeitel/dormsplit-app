import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 25

    @Published var items: [Expense] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("dormsplit_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Expense) {
        items.append(item)
        save()
    }

    func update(_ item: Expense) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Expense) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            items = seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            items = decoded
        } else {
            items = seedData()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }
    }

    private func seedData() -> [Expense] {
        [
        Expense(description: "Sample Description 1", amount: 5.0, payer: "Sample Payer 1"),
        Expense(description: "Sample Description 2", amount: 10.0, payer: "Sample Payer 2"),
        Expense(description: "Sample Description 3", amount: 15.0, payer: "Sample Payer 3")
        ]
    }
}
