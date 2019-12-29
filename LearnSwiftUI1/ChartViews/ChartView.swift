//
//  ChartView.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

class ObsCGFloat: ObservableObject {
    @Published var value: CGFloat = 0.0
}

struct ChartView: View {
    var data: ChartData
    
    // The x coord of interested, relative to self.
    var selectedViewX: CGFloat
    // Output: the data x value corresponding to selectedViewX.
    var selectedXVal: Binding<CGFloat>

    var palette: [Color]

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            GeometryReader { geom in
                ForEach(self.fittedSeries(geom)) { indexedSeries in
                    Path { path in
                        self.fillFromSeries(path: &path, indexedSeries)
                    }
                    .stroke()
                    .foregroundColor(self.seriesColor(indexedSeries))
                }
                // TODO vertical "selection" line
                Path {
                    path in
                    path.addPath(self.selectedXPath(geom))
                }
                .stroke()
                .foregroundColor(.yellow)
                // TODO Axes
                // TODO Legend
            }
            // TODO Overlay vertical line at location of interest.
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

    private func fittedData(_ gp: GeometryProxy) -> ChartData {
        return data.fittedTo(gp.frame(in: .local))
    }
    
    struct IndexedSeries: Identifiable {
        var id: UUID { get { s2d.id } }
        let index: Int
        let s2d: Series2D
    }
    
    private func fittedSeries(_ gp: GeometryProxy) -> [IndexedSeries] {
        return fittedData(gp).series.enumerated().map{ i, v in IndexedSeries(index: i, s2d: v) }
    }
    
    private func fillFromSeries(path: inout Path, _ indexedSeries: IndexedSeries) {
        let dataSeries = indexedSeries.s2d
        let points = dataSeries.values
        guard points.count > 0 else { return }
        
        for i in 1..<points.count {
            path.move(to: points[i - 1])
            path.addLine(to: points[i])
        }
    }
    
    private func seriesColor(_ indexedSeries: IndexedSeries) -> Color {
        return palette[indexedSeries.index % palette.count]
    }
}

