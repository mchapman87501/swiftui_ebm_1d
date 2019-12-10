import Foundation

private struct BandInfo {
    public let dRad: Double
    public let lats: [Double]
}

struct EarthModel {
    let numZones: Int
    let deltaRad: Double
    let latsRad: [Double]
    let latsHeight: [Double]
    let latsFract: [Double]
    let insolByLat: [Double]

    init(numZones zones: Int) {
        let bandInfo = EarthModel.getLatBands(zones)
        let hLat = EarthModel.getBandHeights(bandInfo)
        let lFract = EarthModel.getNormedAreas(bandInfo.lats, hLat)
        let insol = EarthModel.getInsolByLat(lFract)

        numZones = zones
        deltaRad = bandInfo.dRad
        latsRad = bandInfo.lats
        latsHeight = hLat
        latsFract = lFract
        insolByLat = insol
    }

    private static func getLatBands(_ zones: Int) -> BandInfo {
        guard zones > 0 else {
            return BandInfo(dRad: 0.0, lats: [])
        }
        let zoneWidth = (Double.pi / 2.0) / Double(zones)
        let dRad = zoneWidth / 2.0
        var lats = [Double]()
        var bandStart = dRad
        for _ in 0..<zones {
            lats.append(bandStart)
            bandStart += zoneWidth
        }
        return BandInfo(dRad: dRad, lats: lats)
    }

    private static func getBandHeights(_ bandInfo: BandInfo) -> [Double] {
        return bandInfo.lats.map { latStart in
            return sin(latStart + bandInfo.dRad) - sin(latStart - bandInfo.dRad)
        }
    }

    private static func getNormedAreas(_ lats: [Double], _ hLat: [Double]) -> [Double] {
        let radii = lats.map { cos($0) }
        let areas = zip(radii, hLat).map { $0 * $1 }
        let totalArea = areas.reduce(0) { $0 + $1 }
        return areas.map { $0 / totalArea }
    }

    private static func getInsolByLat(_ fract: [Double]) -> [Double] {
        let solConstEff = 1370.0 / 4.0
        return fract.map { solConstEff * $0 }
    }
}
