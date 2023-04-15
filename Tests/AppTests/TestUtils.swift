import Vapor
public func setupTestMongoEnvironmentVariable() {
    Environment.process.MONGO_URL = Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018"
}
