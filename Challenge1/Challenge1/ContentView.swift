//
//  ContentView.swift
//  Challenge1
//
//  Created by Radek Grzywacz on 17/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var measurement = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    @FocusState private var isFocused: Bool
    
    let unitOptions = [
        UnitLength.meters,
        UnitLength.kilometers,
        UnitLength.millimeters,
        UnitLength.centimeters,
        UnitLength.feet,
        UnitLength.miles,
        UnitLength.inches
    ]
    
    var conversionCalc: Measurement<UnitLength> {
        let inputAmount = Measurement(value: Double(measurement) ?? 0, unit: unitOptions[inputUnit])
        let outputAmout = inputAmount.converted(to: unitOptions[outputUnit])
        return outputAmout
    }
    
    var formatter: MeasurementFormatter {
        let newFormat = MeasurementFormatter()
        newFormat.unitStyle = .long
        newFormat.unitOptions = .providedUnit
        return newFormat
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("\(formatter.string(from: unitOptions[inputUnit]))", text: $measurement)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                    
                    Picker("Input unit", selection: $inputUnit){
                        ForEach(0..<unitOptions.count) {
                            let formattedOutput = formatter.string(from: unitOptions[$0])
                            Text("\(formattedOutput)")
                        }
                    }
                    
                    Picker("Output unit", selection: $outputUnit){
                        ForEach(0..<unitOptions.count) {
                            let formattedOutput = formatter.string(from: unitOptions[$0])
                            Text("\(formattedOutput)")
                        }
                    }
                }
                
                Section("Conversion") {
                    Text(formatter.string(from: conversionCalc))
                }
            }
            .navigationTitle("Length Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
