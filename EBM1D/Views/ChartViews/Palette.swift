//
//  Palette.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 1/2/20.
//  Copyright © 2020 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct Palette {
    let colors: [Color]
    
    func color(_ i: Int) -> Color {
        return colors[i % colors.count]
    }
}

extension Palette {
    init(_ colors: [Color]) {
        self.init(colors: colors)
    }
}
