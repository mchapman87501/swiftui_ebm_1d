//
//  ChartView.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct FittedPaths {
    let geom: GeometryProxy
    let data: ChartData
    
    struct SeriesPath: Identifiable {
        let id = UUID()
        let index: Int
        let path: Path
    }

    private func seriesPath(_ dataSeries: Series2D) -> Path {
        var result = Path()
        
        let points = dataSeries.values
        guard points.count > 0 else { return result }
        
        for i in 1..<points.count {
            result.move(to: points[i - 1])
            result.addLine(to: points[i])
        }
        return result
    }
    
    func paths() -> [SeriesPath] {
        let fitted = data.fittedTo(geom.frame(in: .local))
        let paths = fitted.series.map { seriesPath($0) }
        return paths.enumerated().map { i, p in SeriesPath(index: i, path: p) }
    }
}

struct ChartView: View {
    var data: ChartData
    
    // The x coord of interested, relative to self.
    var selectedViewX: CGFloat
    // Output: the data x value corresponding to selectedViewX.
    var selectedXVal: Binding<CGFloat>

    var palette: Palette

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            GeometryReader { geom in
                ForEach(FittedPaths(geom: geom, data: self.data).paths()) { rec in
                    rec.path
                    .stroke()
                        .foregroundColor(self.palette.color(rec.index))
                }
                // vertical "selection" line
                Path {
                    $0.addPath(self.selectedXPath(geom))
                }
                .stroke()
                .foregroundColor(.yellow)
                // TODO Axes
                // TODO Legend
            }
        }
       .foregroundColor(.white)
    }
    
    private func selectedXPath(_ gp: GeometryProxy) -> Path {
        let rect = gp.frame(in: .local)
        self.updateSelectedXVal(gp)
        let x = selectedViewX
        let top = CGPoint(x: x, y: rect.origin.y)
        let bottom = CGPoint(x: x, y: rect.origin.y + rect.size.height)
        var result = Path()
        result.move(to: top)
        result.addLine(to: bottom)
        return result
    }
    
    private func updateSelectedXVal(_ gp: GeometryProxy) {
        let newValue = computedXVal(gp, x: CGFloat(selectedViewX))
        if newValue != self.selectedXVal.wrappedValue {
            DispatchQueue.main.async {
                self.selectedXVal.wrappedValue = newValue
            }
        }
    }

    private func computedXVal(_ gp: GeometryProxy, x: CGFloat) -> CGFloat {
        return self.data.xFitted(x, rect: gp.frame(in: .local))
    }
}

