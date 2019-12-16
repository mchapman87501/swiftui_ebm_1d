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
        maxVal = 150.0
    }
}

// Holds parameters for a recalculation.
struct CalcParameters {
    let numLatBands: Double
    let latHeatTransferCoeff: Double
    let solarMultBounds: SolarMultRange
    let gat0: Double
    let numSolarMultSteps: Int
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
    @Published var solarMultSteps: Int = 10 {
        didSet {
            updateSolutions()
        }
    }
    // TODO Add frozen/thawed albedos and critical temperature.
    
    @Published var chartData = ChartData(series: [Series2D]())
    
    static func seriesFromSolutions(_ solutions: [Model.AvgTempResult], name: String) -> Series2D {
        let values: [CGPoint] = solutions.map {
            solution in
            let solarMult = solution.solarMult
            let gat = solution.solution.avg
            return CGPoint(x: solarMult, y: gat)
        }

        return Series2D(name: name, values: values)
    }

    // Only the main thread accesses these:
    private var pending: CalcParameters? = nil
    private var currentRecalc: DispatchWorkItem? = nil
    
    private func updateWithParams(params: CalcParameters) {
        if currentRecalc == nil {
            // Go now.
            let wrk = DispatchWorkItem {
                let p = params
                let solutions = Model.getSolutions(
                    minSM: p.solarMultBounds.minVal, maxSM: p.solarMultBounds.maxVal,
                    gat0: p.gat0, numZones: Int(p.numLatBands), f: p.latHeatTransferCoeff,
                    steps: p.numSolarMultSteps)
                let allSeries: [Series2D] = [
                    Self.seriesFromSolutions(solutions.rising, name: "Rising"),
                    Self.seriesFromSolutions(solutions.falling, name: "Falling")
                ]
                DispatchQueue.main.async {
                    self.chartData = ChartData(series: allSeries)
                    self.currentRecalc = nil
                    if self.pending != nil {
                        // Go again.
                        let params = self.pending!
                        self.pending = nil
                        self.updateWithParams(params: params)
                    }
                }
            }
            currentRecalc = wrk
            DispatchQueue.global().async(execute:wrk)
        } else {
            // Queue up a new request.
            pending = params
        }
    }

    func updateSolutions() {
        let params = CalcParameters(
            numLatBands: numLatBands, latHeatTransferCoeff: latHeatTransferCoeff,
            solarMultBounds: solarMultBounds, gat0: gat0, numSolarMultSteps: solarMultSteps)
        updateWithParams(params: params)
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
