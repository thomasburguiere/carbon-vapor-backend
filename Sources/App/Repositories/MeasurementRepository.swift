import CarbonLogLib
import MongoDBVapor
import Vapor

struct MeasurementRepositoryKey: StorageKey {
    typealias Value = MeasurementRepository
}

struct MeasurementRepository {
    var collection: MongoCollection<BSONDocument>

    func list() async throws -> [CarbonMeasurement] {
        return try await self.collection.find().toArray().map(toMeasurement)
    }

    func create(measurement: CarbonMeasurement) async throws {
        try await self.collection.insertOne(measurement.toBson())
    }
}

private func toMeasurement(doc: BSONDocument) -> CarbonMeasurement {
    return CarbonMeasurement(
        kg: doc["co2Kg"]!.doubleValue!,
        at: doc["timestamp"]!.dateValue!
    )
}

extension CarbonMeasurement {
    fileprivate func toBson() -> BSONDocument {
        var doc = BSONDocument()
        doc["co2Kg"] = BSON.double(self.carbonKg)
        doc["timestamp"] = BSON.datetime(self.date)
        return doc
    }
}
