//
//  Series2D.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct Series2D: Identifiable {
    let id = UUID()
    let name: String
    let values: [CGPoint]

    func bounds() -> CGRect {
        var result = CGRect.zero
        var first = true
        for p in values {
            let pointRect = CGRect(origin: p, size: CGSize.zero)
            if first {
                first = false
                result = pointRect
            } else {
                result = result.union(pointRect)
            }
        }
        return result
    }

    // So wasteful of memory:
    func applying(_ xform: CGAffineTransform) -> Series2D {
        let newValues = values.map { $0.applying(xform) }
        return Series2D(name: name, values: newValues)
    }
}
