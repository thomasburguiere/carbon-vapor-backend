import MongoKitten
import XCTVapor

@testable import App

final class MeasurementAppTests: XCTestCase {
    let dbUrl =
        Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018" + "/carbon_measurements"
    var db: MongoDatabase?
    var collection: MongoCollection?

    override func setUp() async throws {
        self.db = try await MongoDatabase.connect(to: self.dbUrl)
        self.collection = self.db!["Measurements"]
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
        try app.initializeMongoDB(connectionString: self.dbUrl)

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
        try app.initializeMongoDB(connectionString: self.dbUrl)

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
