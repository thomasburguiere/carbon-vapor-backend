import MongoDBVapor
import Vapor
import CarbonLogLib

struct MeasurementRepositoryKey: StorageKey {
    typealias Value = MeasurementRepository
}

struct MeasurementRepository {
    var collection: MongoCollection<BSONDocument>

    func list() async throws -> Array<CarbonMeasurement> {
      return try await self.collection.find().toArray().map{ $0.toMeasurement() }
    }

    func create(measurement: CarbonMeasurement) async throws {
      try await self.collection.insertOne(measurement.toBson())
    }
}

fileprivate extension BSONDocument {
  func toMeasurement() -> CarbonMeasurement {
    return CarbonMeasurement(
      kg: self["co2Kg"]!.doubleValue!,
      at: self["timestamp"]!.dateValue!
    )
  }
}

fileprivate extension CarbonMeasurement {
  func toBson() -> BSONDocument {
    var doc = BSONDocument()
    doc["co2Kg"] = BSON.double(self.carbonKg)
    doc["timestamp"] = BSON.datetime(self.date)
    return doc
  }
}
