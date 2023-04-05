import MongoDBVapor
import XCTVapor

@testable import App

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer {
            app.mongoDB.cleanup()
            cleanupMongoSwift()
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
