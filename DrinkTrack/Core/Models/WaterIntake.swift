import Foundation
import SwiftData

@Model
class WaterIntake {
    var id: UUID
    var amount: Int // ml cinsinden
    var timestamp: Date

    init(amount: Int, timestamp: Date = .now) {
        self.id = UUID()
        self.amount = amount
        self.timestamp = timestamp
    }
}
