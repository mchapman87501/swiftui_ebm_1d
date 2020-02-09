//
//  ChartView.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 2/9/20.
//  Copyright © 2020 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    @State private var selectedX = CGFloat(0.0)
    // TODO should not know of the "global" ViewModel - use a ChartViewModel
    @ObservedObject var model: ViewModel
    
    
    func xAxModel() -> AxisViewModel {
        let bounds = model.chartData.roundedBounds()
        return AxisViewModel(vMin: bounds.minX, vMax: bounds.maxX)
    }

    func yAxModel() -> AxisViewModel {
        let bounds = model.chartData.roundedBounds()
        return AxisViewModel(vMin: bounds.minY, vMax: bounds.maxY)
    }

    func yAxisWidth() -> CGFloat {
        // TODO learn how to compute natural width of
        // longest tick label
        return 50.0
    }

    func xAxisHeight() -> CGFloat {
        // TODO learn how to compute natural height of
        // tick labels
        return 36.0
    }
    
    func graphWidth(_ geom: GeometryProxy) -> CGFloat {
        let result = geom.size.width - yAxisWidth()
        return (result > 0) ? result : 0.0
    }
    
    func graphHeight(_ geom: GeometryProxy) -> CGFloat {
        let result = geom.size.height - xAxisHeight()
        return (result > 0) ? result : 0.0
    }

    var body: some View {
        GeometryReader { geom in
            VStack(spacing: 0.0) {
                HStack(spacing: 0.0) {
                    YAxisView(model: self.yAxModel())
                        .frame(width: self.yAxisWidth(), height: self.graphHeight(geom))
                    ChartDataView(data: self.model.chartData,
                              selectedViewX: self.selectedX,
                              selectedXVal: self.$model.selectedSolarMult,
                              palette: Palette([.blue, .red]))
                        .frame(width: self.graphWidth(geom), height: self.graphHeight(geom))
                        .foregroundColor(.white)
                        .gesture(DragGesture()
                            .onChanged { value in
                                let loc = value.location
                                let frame = geom.frame(in: .local)
                                // Get the fractional x coord of loc.
                                let offset = loc.x - frame.origin.x
                                self.selectedX = CGFloat(offset)
                            })
                }
                .zIndex(1.0)
                HStack(spacing: 0.0) {
                    Spacer()
                    XAxisView(model: self.xAxModel())
                        .frame(width: self.graphWidth(geom), height: self.xAxisHeight())
                    
                }
            }.clipped()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(model: ViewModel())
    }
}
