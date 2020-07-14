//
//  ContentView.swift
//  LengthConverter
//
//  Created by Michael Lam on 2020-07-13.
//  Copyright © 2020 Michael Lam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput = ""
    @State private var selectedInputUnit = 0
    @State private var selectedOutputUnit = 1
    
    var units = ["metres (m)", "kilometres (km)", "feet (ft)", "yards (yd)", "miles (mi)"]
    
    var calculatedResult: String {
        let input = Double(userInput) ?? 0
        var originalMeasurement, convertedMeasurement: Measurement<UnitLength>
        var result: String
        
        if selectedInputUnit == 0 {
            originalMeasurement = Measurement(value: input, unit: UnitLength.meters)
        } else if selectedInputUnit == 1 {
            originalMeasurement = Measurement(value: input, unit: UnitLength.kilometers)
        } else if selectedInputUnit == 2 {
            originalMeasurement = Measurement(value: input, unit: UnitLength.feet)
        } else if selectedInputUnit == 3 {
            originalMeasurement = Measurement(value: input, unit: UnitLength.yards)
        } else {
            originalMeasurement = Measurement(value: input, unit: UnitLength.miles)
        }
        
        if selectedOutputUnit == 0 {
            convertedMeasurement = originalMeasurement.converted(to: UnitLength.meters)
        } else if selectedOutputUnit == 1 {
            convertedMeasurement = originalMeasurement.converted(to: UnitLength.kilometers)
        } else if selectedOutputUnit == 2 {
           convertedMeasurement = originalMeasurement.converted(to: UnitLength.feet)
        } else if selectedOutputUnit == 3 {
            convertedMeasurement = originalMeasurement.converted(to: UnitLength.yards)
        } else {
            convertedMeasurement = originalMeasurement.converted(to: UnitLength.miles)
        }
        
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit]
        formatter.unitStyle = .long
        result = formatter.string(from: convertedMeasurement)
        
        return result
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Convert length...", text: $userInput)
                    .keyboardType(.decimalPad)
                    Picker(selection: $selectedInputUnit, label: Text("Convert from...")) {
                        ForEach(0 ..< units.count) {
                            Text(self.units[$0])
                        }
                    }
                    Picker(selection: $selectedOutputUnit, label: Text("Convert to...")) {
                        ForEach(0 ..< units.count) {
                            Text(self.units[$0])
                        }
                    }
                }
                Section(header: Text("Conversion Result")) {
                    Text("\(calculatedResult)")
                }
                .navigationBarTitle("Length Converter")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
