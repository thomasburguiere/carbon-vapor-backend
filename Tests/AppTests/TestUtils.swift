import Vapor
import App

public func setupTestMongoEnvironmentVariable() {
    Environment.process.MONGO_URL = Environment.get("MONGO_TEST_URL") ?? "mongodb://localhost:28018"
}
struct TestBearerAuthenticator: AsyncBearerAuthenticator {
    let testBearer: String
    
    init(env: Environment, testBearer: String = "test-foo") throws {
        if env != .testing {
            throw CarbonAppError.illegalTestMode
        }
        self.testBearer = testBearer
    }
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        let isTest = request.application.environment == .testing
        if isTest && bearer.token == self.testBearer {
            request.auth.login(User(name: "TestUser"))
        }
    }
}
