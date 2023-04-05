import CarbonLogLib
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("measurements") { req async throws -> [String] in
        return try await app.measurementRepository.list().map{$0.description}
    }

    app.post("measurements", ":co2Kg") { req async throws in
      let kg: Double = req.parameters.get("co2Kg")!
      try await app.measurementRepository.create(measurement: CarbonMeasurement(carbonKg: kg))
      return HTTPStatus.created
    }
}
