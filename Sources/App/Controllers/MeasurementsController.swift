import CarbonLogLib
import Vapor

struct MeasurementController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let route: RoutesBuilder = routes.grouped("measurements")
            .grouped(BasicAuthenticator())
            .grouped(BearerAuthenticator())
            .grouped(User.guardMiddleware())

        route.get(use: list)
        route.post(":co2Kg", use: create)
        route.post(use: createWithDto)
    }

    func list(req: Request) async throws -> [CarbonMeasurementDto] {
        return try await req.application.measurementRepository.list().map {
            CarbonMeasurementDto(from: $0)
        }
    }

    func create(req: Request) async throws -> HTTPStatus {
        let kg: Double = req.parameters.get("co2Kg")!
        try await req.application.measurementRepository.create(
            measurement: CarbonMeasurement(carbonKg: kg)
        )
        return HTTPStatus.created
    }

    func createWithDto(req: Request) async throws -> HTTPStatus {
        let dto = try req.content.decode(CarbonMeasurementDto.self)
        try await req.application.measurementRepository.create(measurement: dto.asMeasurement)
        return HTTPStatus.created
    }
}
struct CarbonMeasurementDto: Content {

    init(from measurement: CarbonMeasurement) {
        self.co2Kg = measurement.carbonKg
        self.timestamp = measurement.date
    }

    var co2Kg: Double
    var timestamp: Date
    var stringDescription: String?

    var asMeasurement: CarbonMeasurement {
        CarbonMeasurement(kg: self.co2Kg, at: self.timestamp)
    }
}
