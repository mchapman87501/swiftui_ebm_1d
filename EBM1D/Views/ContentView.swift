//
//  ContentView.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 11/16/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedX = CGFloat(0.0)
    @ObservedObject var model = ViewModel()

    var floatFmtr: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        return result
    }()

    var body: some View {
        let labelWidth = CGFloat(128)
        return Form {
            VStack {
                HStack {
                    Slider(value: $model.numLatBands, in: 1...90) {
                        Text("Lat Bands:")
                            .frame(width: labelWidth, alignment: .trailing)
                    }
                    .frame(width: 240)
                    Text("\(model.numLatBands, specifier: "%.0f")")
                        .frame(width: 48, alignment: .trailing)
                    Spacer()
                }
                HStack {
                    Slider(value: $model.latHeatTransferCoeff, in: 0.0...10.0) {
                        Text("Lateral Heat:")
                            .frame(width: labelWidth, alignment: .trailing)
                    }
                    .frame(width: 240)
                    Text("\(model.latHeatTransferCoeff, specifier: "%.2f")")
                        .frame(width: 48, alignment: .trailing)
                    Spacer()
                }
                // Why this?  Because the Stepper label on macOS is, unaccountably, arranged to
                // appear on a line above the indented stepper.
                HStack {
                    Text("Solar mult. steps:")
                        .frame(width: labelWidth, alignment: .trailing)
                    Text("\(model.solarMultSteps)")
                        .frame(width: 36, alignment: .trailing)
                    Stepper(value: $model.solarMultSteps, in: 5...200, step: 5) {
                        Text("")
                    }
                    .labelsHidden()
                    Spacer()
                }
                Divider()

                GeometryReader { geom in
                    ChartView(data: self.model.chartData,
                              selectedViewX: self.selectedX,
                              selectedXVal: self.$model.selectedSolarMult,
                              palette: Palette([.blue, .red]))
                        .frame(minWidth: 240, minHeight: 240)
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

                HStack {
                    Spacer()
                    VStack {
                        Text("Rising")
                            .foregroundColor(.blue)
                        GlobeView(albedos: model.albedos.risingAlbedos)
                            .frame(minHeight: 128)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    }
                    Spacer()
                    VStack {
                        Text("Falling")
                            .foregroundColor(.red)
                        GlobeView(albedos: self.model.albedos.fallingAlbedos)
                            .frame(minHeight: 128)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    }
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
        return ContentView()
    }
}
