import CarbonLogLib
import MongoKitten
import Vapor

struct MeasurementRepositoryKey: StorageKey {
    typealias Value = MeasurementRepository
}

struct MeasurementRepository {
    var collection: MongoCollection

    func list() async throws -> [CarbonMeasurement] {
        return try await self.collection.find().map(transform: toMeasurement).drain()
    }

    func create(measurement: CarbonMeasurement) async throws {
        try await self.collection.insert(measurement.toDocument())
    }
}

private func toMeasurement(doc: Document) -> CarbonMeasurement {
    return CarbonMeasurement(
        kg: doc["co2Kg"] as! Double,
        at: doc["timestamp"] as! Date
    )
}

extension CarbonMeasurement {
    fileprivate func toDocument() -> Document {
        var doc = Document()
        doc["co2Kg"] = self.carbonKg
        doc["timestamp"] = self.date
        return doc
    }
}
