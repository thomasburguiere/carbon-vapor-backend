import Vapor

struct User: Authenticatable {
    var name: String
}

struct BasicAuthenticator: AsyncBasicAuthenticator {
    func authenticate(basic: BasicAuthorization, for request: Request) async throws {
        print(basic)
        if basic.username == "user" && basic.password == "secret" {
            request.auth.login(User(name: "Vapor"))
        }
    }
}

struct BearerAuthenticator: AsyncBearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        print(bearer)
        if bearer.token == "foo" {
            request.auth.login(User(name: "Vapor"))
        }
    }
}
