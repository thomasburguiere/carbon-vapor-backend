import MongoKitten
import XCTVapor

@testable import App

final class MeasurementAppTests: XCTestCase {
    static var db: MongoDatabase?
    var collection: MongoCollection?

    override class func setUp() {
        setupTestMongoEnvironmentVariable()
        let dbUrl =
            "\(Environment.get("MONGO_URL")!)/carbon_measurements"
        do { MeasurementAppTests.db = try MongoDatabase.lazyConnect(to: dbUrl) } catch {
            print("Unexpected error: \(error).")
        }
    }

    override func setUp() async throws {
        self.collection = MeasurementAppTests.db!["Measurements"]
    }

    override func tearDown() async throws {
        try await self.collection!.deleteAll(where: Document())
    }

    func testListEmptyMeasurements() throws {
        let app = Application(.testing)
        defer {
            app.shutdown()
        }
        try configure(app)

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
                XCTAssertTrue(
                    res.body.string.contains(expectedContent),
                    "expected response body to contain \"\(expectedContent)...\", actually got \(res.body.string)"
                )
            }
        )
    }
}
