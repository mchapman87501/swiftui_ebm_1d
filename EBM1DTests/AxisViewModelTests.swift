//
//  AxisViewModelTests.swift
//  EBM1DTests
//
//  Created by Mitchell Chapman on 2/11/20.
//  Copyright © 2020 Desert Moon Consulting, LLC. All rights reserved.
//

import XCTest
@testable import EBM1D

class AxisViewModelTests: XCTestCase {
    func testAutoTicks1() {
        let model = AxisViewModel(vMin: -10.0, vMax: 80.0)
        let expected: [CGFloat] = [-10.0, 20.0, 50.0, 80.0]
        let actual = model.ticks
        XCTAssertEqual(expected, actual)
    }

    func testAutoTicks2() {
        let model = AxisViewModel(vMin: 0.0, vMax: 75.0)
        let expected: [CGFloat] = [0.0, 25.0, 50.0, 75.0]
        let actual = model.ticks
        XCTAssertEqual(expected, actual)
    }
    
    func testAutoTicks3() {
        let model = AxisViewModel(vMin: 0.0, vMax: 70.0)
        let expected: [CGFloat] = [0.0, 17.5, 35.0, 52.5, 70.0]
        let actual = model.ticks
        XCTAssertEqual(expected, actual)
    }
}
