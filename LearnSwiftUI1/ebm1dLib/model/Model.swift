struct Model {
    struct AvgTempResult {
        let delta: Double
        let solarMult: Double
        let solution: TempSolver.Solution
    }

    func getSolutions(
        minSM minSolarMult: Double, maxSM maxSolarMult: Double,
        gat0 globalAvgTemp0: Double, numZones: Int,
        f latTransferCoeff: Double = Defaults.latTransferCoeff
    ) -> [AvgTempResult] {
        let em = EarthModel(numZones: numZones)
        let solver = TempSolver(em: em, f: latTransferCoeff)

        let gat0 = [Double](repeating: globalAvgTemp0, count: numZones)

        let numSolarMults = 10
        let delta = (maxSolarMult - minSolarMult) / Double(numSolarMults)

        let smRising = stride(
            from: minSolarMult, to: maxSolarMult, by: delta).map {$0}
        let smFalling = stride(
            from: maxSolarMult, to: minSolarMult, by: -delta).map {$0}

        var result = [AvgTempResult]()
        result.reserveCapacity(2 * numSolarMults)
        var temps = gat0
        for smSeq in [smRising, smFalling] {
            for sm in smSeq {
                if let solution = try? solver.solve(
                    solarMultiplier: sm, temp: temps
                ) {
                    let record = AvgTempResult(
                        delta: delta, solarMult: sm, solution: solution)
                    result.append(record)
                    temps = solution.temps
                }
            }
        }
        return result
    }
}