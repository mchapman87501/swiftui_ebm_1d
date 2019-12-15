//
//  ContentView.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 11/16/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModel()
    
    var floatFmtr: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    var body: some View {
        let mag = MagnificationGesture()
            .onChanged {
                mag in
                self.model.scaleMultipliersBy(mag)
            }
            .onEnded {
                mag in
                self.model.scaleMultipliersBy(mag)
            }
        
        let resetMag = TapGesture(count: 2)
            .onEnded { _ in
                self.model.resetMultipliers()
            }
        
        return Form {
            VStack(alignment: .leading) {
                HStack {
                    Slider(value: $model.numLatBands, in: 1...90) {
                        Text("Lat Bands:")
                            .frame(width: 84, alignment: .trailing)
                    }
                    .frame(width: 240)
                    Text("\(model.numLatBands, specifier: "%.0f")")
                        .frame(width: 48, alignment: .trailing)
                    Spacer()
                }
                HStack {
                    Slider(value: $model.latHeatTransferCoeff, in: 0.0...10.0) {
                        Text("Lateral Heat:")
                            .frame(width: 84, alignment: .trailing)
                    }
                    .frame(width: 240)
                    Text("\(model.latHeatTransferCoeff, specifier: "%.2f")")
                        .frame(width: 48, alignment: .trailing)
                    Spacer()
                }
                Divider()
                
                GeometryReader { geom in
                    ChartView(data: self.model.chartData, palette: [.blue, .red])
                        .frame(minWidth: 240, minHeight: 240)
                        .foregroundColor(.white)
                        .gesture(mag)
                        .gesture(resetMag)
                        .gesture(DragGesture()
                            .onChanged { info in
                                let dxRaw = info.location.x - info.startLocation.x
                                let dxFract = -dxRaw / geom.frame(in: .local).width
                                // TODO let shiftMultipliers distinguish between "transient" and "final" changes.
                                self.model.shiftMultipliers(dxFract)
                            }
                            .onEnded { info in
                                let dxRaw = info.location.x - info.startLocation.x
                                let dxFract = -dxRaw / geom.frame(in: .local).width
                                self.model.shiftMultipliers(dxFract)
                            })
                }

                HStack {
                    Spacer()
                    Rectangle()
                        .frame(minHeight: 128)
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    Spacer()
                    Rectangle()
                        .frame(minHeight: 128)
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    Spacer()
                }
            }
            .padding()
        }
        .frame(minWidth: 640, minHeight: 640)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
