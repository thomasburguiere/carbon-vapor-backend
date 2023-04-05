import Vapor
import CarbonLogLib

struct MeasurementController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
       let route: RoutesBuilder = routes.grouped("measurements") 

       route.get(use: list)
       route.post(":co2Kg", use: create)
    }

    func list(req: Request) async throws -> [String] {
      return try await req.application.measurementRepository.list().map{$0.description}
    }

    func create(req: Request) async throws -> HTTPStatus {
      let kg: Double = req.parameters.get("co2Kg")!
      try await req.application.measurementRepository.create(measurement: CarbonMeasurement(carbonKg: kg))
      return HTTPStatus.created
    }
}