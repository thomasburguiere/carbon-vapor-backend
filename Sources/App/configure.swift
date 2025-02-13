@preconcurrency import MongoKitten
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)

    // Configure the app for using a MongoDB server at the provided connection string.
    let mongoUrl = Environment.get("MONGO_URL")!
    try app.initializeMongoDB(connectionString: "\(mongoUrl)/carbon_measurements")
}

private struct MongoDBStorageKey: StorageKey {
    typealias Value = MongoDatabase
}

public extension Application {
    var mongoDB: MongoDatabase {
        get {
            storage[MongoDBStorageKey.self]!
        }
        set {
            storage[MongoDBStorageKey.self] = newValue
        }
    }

    func initializeMongoDB(connectionString: String) throws {
        mongoDB = try MongoDatabase.lazyConnect(to: connectionString)
    }

    internal var measurementRepository: MeasurementRepository {
        if let repo: MeasurementRepository = storage[MeasurementRepositoryKey.self] {
            return repo
        } else {
            let collection: MongoCollection = mongoDB["Measurements"]
            let repo = MeasurementRepository(collection: collection)
            storage[MeasurementRepositoryKey.self] = repo
            return repo
        }
    }
}
