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

final class ViewModel: ObservableObject {
    @Published var dirty = false
    
    @Published var numLatBands: Double = 9.0 {
        didSet {
            dirty = true
        }
    }
    @Published var latHeatTransferCoeff: Double = 7.6 {
        didSet {
            dirty = true
        }
    }
    @Published var minSolarMult: Double = 0.1 {
        didSet {
            dirty = true
        }
    }
    @Published var maxSolarMult: Double = 100.0 {
        didSet {
            dirty = true
        }
    }
    @Published var gat0: Double = -60.0 {
        didSet {
            dirty = true
        }
    }
    // TODO Add frozen/thawed albedos and critical temperature.
    
//    @Published var globalStates = [GlobalStateSolution]() {
//        didSet {
//            dirty = false
//        }
//    }
//
    @Published var chartData = ChartData(series: [Series2D]()) {
        didSet {
            print("Updated chartData.")
            dirty = false
        }
    }
    
    func updateSolutions() {
        print("updateSolutions for \(minSolarMult), \(maxSolarMult), \(gat0), \(Int(numLatBands)), \(latHeatTransferCoeff)")
        let solutions = Model.getSolutions(minSM: minSolarMult, maxSM: maxSolarMult, gat0: gat0, numZones: Int(numLatBands), f: latHeatTransferCoeff)
//        let solvedStates: [GlobalStateSolution] = solutions.map { solution in
//            let solarMult = solution.solarMult
//            let gat = solution.solution.avg
//            return CGPoint(x: solarMult, y: gat)
//        }
        
        let values: [CGPoint] = solutions.map {
            solution in
            let solarMult = solution.solarMult
            let gat = solution.solution.avg
            return CGPoint(x: solarMult, y: gat)
        }

//        globalStates = solvedStates

        let theSeries = Series2D(name: "Rising/Falling", values: values)
        print("  Solutions: \(values)")
        chartData = ChartData(series: [theSeries])
    }
    
    init() {
        numLatBands = 9.0
        latHeatTransferCoeff = 7.6
        minSolarMult = 0.1
        maxSolarMult = 100
        gat0 = -60.0
        updateSolutions()
    }
    
}
