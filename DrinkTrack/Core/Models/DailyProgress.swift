import Foundation

struct DailyProgress: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let totalAmount: Int
    let goal: Int

    var percentage: Double {
        guard goal > 0 else { return 0 }
        return min(Double(totalAmount) / Double(goal), 1.0)
    }

    var isGoalMet: Bool {
        totalAmount >= goal
    }

    var contributionLevel: Int {
        switch percentage {
        case 0:
            return 0
        case 0.01..<0.25:
            return 1
        case 0.25..<0.50:
            return 2
        case 0.50..<1.0:
            return 3
        default:
            return 4
        }
    }
}
