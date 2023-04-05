import MongoDBVapor
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)

    // Configure the app for using a MongoDB server at the provided connection string.
    try app.mongoDB.configure("mongodb://localhost:27017")
}

extension Application {

    var measurementRepository: MeasurementRepository {
        let collection = self.mongoDB.client.db("carbon_measurements")
            .collection("Measurements")
        return MeasurementRepository(collection: collection)
    }
}
