import MongoKitten
import Testing
import VaporTesting

@testable import App

struct AppTests {
    init() async throws {
        setupTestMongoEnvironmentVariable()
    }

    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await test(app)
        } catch {
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test func testHelloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "hello") { res in

                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            }
        }
    }
}
