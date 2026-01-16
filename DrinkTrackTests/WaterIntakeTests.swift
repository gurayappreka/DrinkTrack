import XCTest
@testable import DrinkTrack

final class WaterIntakeTests: XCTestCase {

    func testInitializationWithAmount() {
        let intake = WaterIntake(amount: 250)
        XCTAssertEqual(intake.amount, 250)
        XCTAssertNotNil(intake.id)
    }

    func testInitializationWithCustomTimestamp() {
        let customDate = Date(timeIntervalSince1970: 1000)
        let intake = WaterIntake(amount: 500, timestamp: customDate)
        XCTAssertEqual(intake.amount, 500)
        XCTAssertEqual(intake.timestamp, customDate)
    }

    func testDefaultTimestampIsNow() {
        let before = Date()
        let intake = WaterIntake(amount: 100)
        let after = Date()
        XCTAssertGreaterThanOrEqual(intake.timestamp, before)
        XCTAssertLessThanOrEqual(intake.timestamp, after)
    }
}
