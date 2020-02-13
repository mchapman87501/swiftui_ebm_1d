//
//  AxisLimitsTests.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 2/11/20.
//  Copyright © 2020 Desert Moon Consulting, LLC. All rights reserved.
//

import XCTest
import Foundation
@testable import EBM1D

class AxisLimitsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testAdjustedExtents1() {
        let limits = AxisLimits(minVal: -123.27, extent: 923.0 - -123.27)
        XCTAssertEqual(limits.axMin, -200.0)
        XCTAssertEqual(limits.axMax, 1000.0)
    }

    func testAdjustedExtents2() {
        let limits = AxisLimits(minVal: 28.0, extent: 900.0)
        XCTAssertEqual(limits.axMin, 0.0)
        XCTAssertEqual(limits.axMax, 930.0)
    }
    
    func testAdjustedExtents3() {
        let axLimits = AxisLimits(minVal: 400.0, extent: 892.5 - 400.0)
        XCTAssertEqual(axLimits.axMin, 400.0)
        XCTAssertEqual(axLimits.axMax, 900.0)
    }
    
    func testAdjustedExtents4() {
        let axLimits = AxisLimits(minVal: 119.0, extent: 532.5 - 119.0)
        XCTAssertEqual(axLimits.axMin, 0.0)
        XCTAssertEqual(axLimits.axMax, 540.0)
    }

    func testAdjustedExtents5() {
        let axLimits = AxisLimits(minVal: -93.68, extent: 2115.49 - -93.68)
        XCTAssertEqual(axLimits.axMin, -100.0)
        XCTAssertEqual(axLimits.axMax, 2200.0)
    }
    
    func testAdjustedExtents6() {
        let axLimits = AxisLimits(minVal: 0.01, extent: 120.0 - 0.01)
        // Would prefer if axMin were 0.0, in this case:
        XCTAssertEqual(axLimits.axMin, -10.0)
        XCTAssertEqual(axLimits.axMax, 120.0)
    }
}
