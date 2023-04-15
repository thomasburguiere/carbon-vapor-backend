import MongoKitten
import XCTVapor

@testable import App

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(Environment.testing)
        defer {
            app.shutdown()
        }
        try configure(app)

        try app.test(
            .GET,
            "hello",
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertEqual(res.body.string, "Hello, world!")
            }
        )
    }
}
