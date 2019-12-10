//
//  ObservableModel.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 12/9/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI
import Combine

final class ObservableModel: ObservableObject {
    @Published var numLatBands: Double = 9.0
    @Published var latHeatTransferCoeff: Double = 7.6
    @Published var minSolarMult: Double = 0.1
    @Published var maxSolarMult: Double = 100.0
    @Published var gat0: Double = -60.0
    @Published var solutions = [Model.AvgTempResult]()
    
    func updateSolutions() {
        solutions = Model().getSolutions(minSM: minSolarMult, maxSM: maxSolarMult, gat0: gat0, numZones: Int(numLatBands), f: latHeatTransferCoeff)
    }
    
}
