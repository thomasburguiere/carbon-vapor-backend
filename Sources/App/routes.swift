import CarbonLogLib
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("measurement") { req async -> String in
        let meas = CarbonMeasurement(kg: 0.5, at: Date.now)
        return "Measurement: " + meas.description
    }
}
