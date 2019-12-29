//
//  AlbedoViewModel.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 12/29/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI
import ebm1dLib

class AlbedoViewModel: ObservableObject {
    public var solutions: Model.Result

    struct AlbedosForSolarMult {
        let solarMult: Double
        let albedos: [Double]
    }
    typealias AlbedoSeries = [AlbedosForSolarMult]
    private var allRisingAlbedos = AlbedoSeries()
    private var allFallingAlbedos = AlbedoSeries()

    @Published var risingAlbedos = [Double]()
    @Published var fallingAlbedos = [Double]()
    
    static func albedosFromSolutions(_ solutions: [Model.AvgTempResult]) -> AlbedoSeries {
        guard solutions.count > 0 else {
            return []
        }
        
        return solutions.map { solution in
            AlbedosForSolarMult(solarMult: solution.solarMult, albedos: solution.solution.albedos)
        }
    }

    static func nearestAlbedos(solarMult: CGFloat, albedos: AlbedoSeries) -> [Double] {
        var result = [Double]()
        let sm = Double(solarMult)
        var minDist = 0.0
        for (i, record) in albedos.enumerated() {
            if i == 0 {
                minDist = fabs(record.solarMult - sm)
                result = record.albedos
            } else {
                let dist = fabs(record.solarMult - sm)
                if dist < minDist {
                    minDist = dist
                    result = record.albedos
                }
            }
        }
        return result
    }

    init(solutions initSolutions: Model.Result, selectedSolarMult ssm: CGFloat) {
        let allRising = Self.albedosFromSolutions(initSolutions.rising)
        let allFalling = Self.albedosFromSolutions(initSolutions.falling)
        let risingAlbedos = Self.nearestAlbedos(solarMult: ssm, albedos: allRising)
        let fallingAlbedos = Self.nearestAlbedos(solarMult: ssm, albedos: allFalling)

        solutions = initSolutions
        allRisingAlbedos = allRising
        allFallingAlbedos = allFalling
        self.risingAlbedos = risingAlbedos
        self.fallingAlbedos = fallingAlbedos
    }
}
