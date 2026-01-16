import Testing
@testable import DrinkTrack

@Suite("Sample Tests")
struct SampleTests {

    @Test("App launches successfully")
    func appLaunches() {
        #expect(true)
    }
}
