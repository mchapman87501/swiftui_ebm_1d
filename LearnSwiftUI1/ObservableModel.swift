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
}
