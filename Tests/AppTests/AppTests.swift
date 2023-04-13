import MongoKitten
import XCTVapor

@testable import App

final class AppTests: XCTestCase {

    override func tearDown() async throws {
        let url = Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018"
        let db: MongoDatabase = try await MongoDatabase.connect(to: "\(url)/carbon_measurements")
        let collection: MongoCollection = db["Measurements"]
        try await collection.deleteAll(where: Document())
    }

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
    func testListEmptyMeasurements() throws {
        let app = Application(.testing)
        defer {
            app.shutdown()
        }
        try configure(app)
        let url = Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018"
        try app.initializeMongoDB(connectionString: "\(url)/carbon_measurements")

        try app.test(
            .GET,
            "measurements",
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertEqual(res.body.string, "[]")
            }
        )
    }

    func testCreateMeasurement() throws {
        let app = Application(.testing)
        defer {
            app.shutdown()
        }
        try configure(app)
        let url = Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018"
        try app.initializeMongoDB(connectionString: "\(url)/carbon_measurements")

        try app.test(
            .POST,
            "measurements/42.0",
            afterResponse: { res in
                XCTAssertEqual(res.status, .created)
            }
        )

        try app.test(
            .GET,
            "measurements",
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                let expectedContent = "[{\"co2Kg\":42,\"timestamp\":"
                XCTAssertTrue(res.body.string.contains(expectedContent), "expected response body to contain \"\(expectedContent)...\", actually got \(res.body.string)")
            }
        )
    }
}
