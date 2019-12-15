//
//  ChartView.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    var data: ChartData
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
                // TODO Axes
                // TODO Legend
            }
        }
       .foregroundColor(.white)
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

