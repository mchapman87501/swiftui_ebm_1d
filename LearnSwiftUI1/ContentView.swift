//
//  ContentView.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 11/16/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ObservableModel
    
    var floatFmtr: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                HStack {
                    Text("Lat Bands: 1")
                    Slider(value: $model.numLatBands, in: 1...90)
                        .frame(maxWidth: 240)
                    Text("90")
                }
                HStack {
                    Text("Lateral Heat:")
                    TextField("7.6", value: $model.latHeatTransferCoeff,
                              formatter: floatFmtr)
                        .frame(maxWidth: 40)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Spacer()
                    Button(action: model.updateSolutions) {
                        Text("Update")
                    }
                    Spacer()
                }
                
                Divider()
                
                // Placeholder for the plots:
                Rectangle()
                    .foregroundColor(.white)
                    .frame(minHeight: 240)

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
        .environmentObject(ObservableModel())
    }
}
