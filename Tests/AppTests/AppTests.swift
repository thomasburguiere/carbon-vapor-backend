import MongoKitten
import Testing
import XCTVapor

@testable import App

struct AppTests {

    init() async throws {
        setupTestMongoEnvironmentVariable()
    }

    @Test  func testHelloWorld() async throws {
        let app: Application = try await Application.make(Environment.testing)
        // defer {
            try await app.asyncShutdown()()
        // }
        try configure(app)

        try await app.test(
            .GET,
            "hello",
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertEqual(res.body.string, "Hello, world!")
            }
        )
    }
}
