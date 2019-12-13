//
//  ObservableModel.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 12/9/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI
import Combine

import ebm1dLib

// x == solar multiplier
// y == steady-state global average temperature
typealias GlobalStateSolution = CGPoint

struct SolarMultRange {
    public let minVal: Double
    public let maxVal: Double
}
extension SolarMultRange {
    init() {
        minVal = 0.1
        maxVal = 100.0
    }
}

final class ViewModel: ObservableObject {
    @Published var numLatBands: Double = 9.0 {
        didSet {
            updateSolutions()
        }
    }
    @Published var latHeatTransferCoeff: Double = 7.6 {
        didSet {
            updateSolutions()
        }
    }
    @Published var solarMultBounds: SolarMultRange = SolarMultRange() {
        didSet {
            updateSolutions()
        }
    }
    @Published var gat0: Double = -60.0 {
        didSet {
            updateSolutions()
        }
    }
    // TODO Add frozen/thawed albedos and critical temperature.
    
    @Published var chartData = ChartData(series: [Series2D]())
    
    func updateSolutions() {
        let solutions = Model.getSolutions(
            minSM: solarMultBounds.minVal, maxSM: solarMultBounds.maxVal,
            gat0: gat0, numZones: Int(numLatBands), f: latHeatTransferCoeff)
        
        let values: [CGPoint] = solutions.map {
            solution in
            let solarMult = solution.solarMult
            let gat = solution.solution.avg
            return CGPoint(x: solarMult, y: gat)
        }

        let theSeries = Series2D(name: "Rising/Falling", values: values)
        chartData = ChartData(series: [theSeries])
    }
    
    func scaleMultipliersBy(_ scale: CGFloat) {
        guard scale > 0 else {
            return
        }
        let sm0 = solarMultBounds.minVal
        let sm1 = solarMultBounds.maxVal
        let smMid = (sm0 + sm1) / 2.0
        let smHalf = (sm1 - sm0) / 2.0
        let newSMHalf = smHalf / Double(scale)
        
        solarMultBounds = SolarMultRange(minVal: smMid - newSMHalf, maxVal: smMid + newSMHalf)
    }
    
    func shiftMultipliers(_ fractOffset: CGFloat) {
        let curr = solarMultBounds
        let off = Double(fractOffset) * (curr.maxVal - curr.minVal)
        solarMultBounds = SolarMultRange(minVal: curr.minVal + off, maxVal: curr.maxVal + off)
    }
    
    func resetMultipliers() {
        solarMultBounds = SolarMultRange()
    }
    
    init() {
        numLatBands = 9.0
        latHeatTransferCoeff = 7.6
        solarMultBounds = SolarMultRange()
        gat0 = -60.0
        updateSolutions()
    }
}
