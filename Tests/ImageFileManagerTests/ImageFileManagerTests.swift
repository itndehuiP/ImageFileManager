import XCTest
@testable import ImageFileManager

final class ImageFileManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ImageFileManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
