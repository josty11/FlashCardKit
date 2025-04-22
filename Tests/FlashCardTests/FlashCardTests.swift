import XCTest
@testable import FlashCard

final class FlashCardTests: XCTestCase {
    
    func testFlashCardInitialization() {
        let card = FlashCard(frontText: "Test", backText: "tseT")
        XCTAssertEqual(card.frontText, "Test")
        XCTAssertEqual(card.backText, "tseT")
    }
}
